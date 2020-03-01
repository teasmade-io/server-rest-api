import std.datetime;
import std.experimental.logger;

import serialport;
import vibe.d;

import rest.ActuatorRest;
import rest.SensorRest;

void serial_read_thread_fn(string serial_device_path, shared(SensorRest) sensor)
{
	bool running = true;
	auto serial_device = new SerialPortBlk(serial_device_path, 9600);
	scope(exit)
	{
		serial_device.close();
		log("Connection to " ~ serial_device_path ~ " closed");
	}

	char[] buffer;
	int r_start = 0, r_end = 0;
	while (running)
	{
		try
		{
			// Check Parent Thread Liveness
			auto message = receiveTimeout(dur!"msecs"(1));

			char[256] buf_read = 0;
			char[] result = cast(char[]) serial_device.read(buf_read, SerialPort.CanRead.anyNonZero);
			debug log("Read buffer[", to!string(result.length) ~ "]: ", to!string(result));

			buffer = buffer ~ result;

			for (ptrdiff_t s = buffer.indexOf(";\r\n"); s != -1; )
			{
				// Check validity
				bool correct_ascii = true;
				foreach (char c; buffer[0 .. s])
				{
					import std.ascii;
					if (!c.isASCII()) {
						correct_ascii = false;
						break;
					}
				}
				
				if (correct_ascii && buffer[0 .. s].count(',') == 9)
				{
					import std.conv;
					// Parse serial data
					try {
						sensor.update(buffer[0 .. s]);
					} catch (ConvException e) {}
				}

				// Update buffer and next delimiter
				buffer = buffer[s + 3 .. $];
				s = buffer.indexOf(";\r\n", s);
			}

		} catch (TimeoutException e) {
		} catch (ReadException e) {
		} catch (SysCallException e) {
		} catch (OwnerTerminated e)
		{
			running = false;
		} catch (PortClosedException e)
		{
			running = false;
		} catch (Exception e) {
			log("Exception occurred while receiving and parsing serial data: ", e);
		}
	}
}

string get_serial_device()
{
	string[] devices = SerialPortBase.listAvailable();
	auto likely_devices = devices.filter!(s => (s.indexOf("ttyACM") > 0 || s.indexOf("tty.usbmodem") > 0)).array();
	if (likely_devices.length > 1)
	{
		log("Multiple serial devices found: ", likely_devices);
	}
	else if (likely_devices.length == 0)
	{
		log("No serial devices detected.");
		return null;
	}
	return likely_devices[0];
}

void main()
{
	log("Starting teasmade-io REST API");

	auto router = new URLRouter();
	auto sensor = new shared(SensorRest);
	auto actuator = new ActuatorRest();

	router.registerRestInterface(sensor);
	router.registerRestInterface(actuator);

	string sensor_device_path = get_serial_device();
	if (sensor_device_path == null) return;
	log("Connecting to platform sensor hub device: ", sensor_device_path);

	auto sensor_thread = spawn(&serial_read_thread_fn, sensor_device_path, sensor);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;

	auto listener = listenHTTP(settings, router);
	scope(exit)
	{
		listener.stopListening();
	}

	log("Started teasmade-io REST API");

	runApplication();
}
