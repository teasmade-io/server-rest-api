module rest.SensorRest;

import rest.ISensor;

class SensorRest : ISensor
{

    float getTemperature()
    {
        return overhead_.temp;
    }

    overhead_status overhead_;
}