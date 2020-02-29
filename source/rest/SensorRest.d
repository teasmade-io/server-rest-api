module rest.SensorRest;

import rest.ISensor;

synchronized class SensorRest : ISensor
{

    this()
    {
        overhead_.temp = 0.0;
    }

    override float getTemperature()
    {
        return overhead_.temp;
    }

    private overhead_status overhead_;
}