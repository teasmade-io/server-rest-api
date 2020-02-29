module rest.ISensor;

import vibe.d;

synchronized interface ISensor
{

    struct steam_status {
        float temp;
        float pressure;
        float humidity;
    }

    @path("/api/v1/steam/temperature")
    float get_steam_temperature() @safe;
    @path("/api/v1/steam/pressure")
    float get_steam_pressure() @safe;
    @path("/api/v1/steam/humidity")
    float get_steam_humidity() @safe;

    struct jug_status {
        bool rfid;
    }

    @path("/api/v1/jug/connected")
    float get_jug_connected() @safe;

    struct tea_colour_status {
        uint red;
        uint green;
        uint blue;
        uint clear_light;
    }

    @path("/api/v1/tea/colour")
    tea_colour_status get_tea_colour() @safe;

    struct tea_level_status {
        float ping_cm;
        uint ir_proximity;
    }

    @path("/api/v1/tea/level")
    float get_tea_level() @safe;

}