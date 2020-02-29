module rest.ISensor;

import vibe.d;

synchronized interface ISensor
{

    struct overhead_status {
        float temp;
    }

    @path("/api/v1/temperature")
    float getTemperature();
}