module rest.SensorRest;

import rest.ISensor;

synchronized class SensorRest : ISensor
{

    this()
    {
        steam.temp = 0.0;
    }

    void update(char[] raw)
    {
        import std.array;
        import std.conv;
        auto line = raw.split("\r\n")[0];
        auto data = line.split(",");
        debug
        {
            import std.experimental.logger;
            debug log("sensor data: \"", line,"\"");
        }
        if (data.length != 10) return;

        steam.temp = to!float(data[0]);
        steam.pressure = to!float(data[1]);
        steam.humidity = to!float(data[2]);

        tea_colour.red = to!uint(data[3]);
        tea_colour.green = to!uint(data[4]);
        tea_colour.blue = to!uint(data[5]);
        tea_colour.clear_light = to!uint(data[6]);

        jug.rfid = cast(bool) to!uint(data[7]);
        
        tea_level.ping_cm = to!float(data[8]);
        tea_level.ir_proximity = to!uint(data[9]);
    }

    override float get_steam_temperature() @safe
    {
        return steam.temp;
    }

    override float get_steam_pressure() @safe
    {
        return steam.pressure;
    }

    override float get_steam_humidity() @safe
    {
        return steam.humidity;
    }

    override float get_jug_connected() @safe
    {
        return jug.rfid;
    }

    override tea_colour_status get_tea_colour() @safe
    {
        return tea_colour;
    }

    override float get_tea_level() @safe
    {
        return tea_level.ping_cm;
    }

    private steam_status steam;
    private jug_status jug;
    private tea_colour_status tea_colour;
    private tea_level_status tea_level;
}