import std.datetime;
import std.experimental.logger;

import serialport;
import vibe.d;

import rest.ActuatorRest;
import rest.SensorRest;

void serial_read_thread_fn(string serial_device_path, shared(SensorRest) sensor, shared(ActuatorRest) actuator)
{
	int retry = 0;
	auto serial_device = new SerialPortBlk(serial_device_path, 9600);
	scope(exit)
	{
		serial_device.close();
		log("Connection to " ~ serial_device_path ~ " closed");
	}

	try
	{
		while (!receiveTimeout(dur!"msecs"(250), (bool v) {}) && !serial_device.closed)
		{
			byte[] buffer;
			auto result = serial_device.read(buffer);
			log("Read buffer[" ~ to!string(result.length) ~ "]: " ~ to!string(cast(char[])result));
		}
	} catch (OwnerTerminated e) {}
}

void main()
{
	log("Starting teasmade-io REST API");

	auto router = new URLRouter();
	auto sensor = new shared(SensorRest);
	auto actuator = new shared(ActuatorRest);

	router.registerRestInterface(sensor);
	router.registerRestInterface(actuator);

	string sensor_device_path = SerialPortBase.listAvailable()[0];
	sensor_device_path = "/dev/tty.usbmodem14101";
	log("Connecting to platform sensor hub device: " ~ sensor_device_path);

	auto sensor_thread = spawn(&serial_read_thread_fn, sensor_device_path, sensor, actuator);

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
