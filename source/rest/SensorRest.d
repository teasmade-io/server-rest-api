module rest.SensorRest;

import rest.ISensor;

class SensorRest : ISensor
{

    this()
    {
        overhead_.temp = 0.0;
    }

    float getTemperature()
    {
        return overhead_.temp;
    }

    overhead_status overhead_;
}