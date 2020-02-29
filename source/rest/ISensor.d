module rest.ISensor;

import vibe.d;

interface ISensor
{

    struct overhead_status {
        float temp;
    }

    @path("/api/v1/temperature")
    float getTemperature();
}