module rest.ActuatorRest;

import std.datetime;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart;

import rest.IActuator;

class ActuatorRest : IActuator
{

    this()
    {
    }

    override int brew() @safe
    {
        if (seconds_since_brew() > 30)
        {
            brew_status_.sw = new StopWatch(AutoStart.yes);
            return 200; // 200: OK
        } else {
            return 300; // 300: Temporarily Unavailable
        }
    }

    override long seconds_since_brew() @safe
    {
        if (brew_status_.sw == null) 
        {
            return 100000;
        }
        else {
            return brew_status_.sw.peek().total!"seconds";
        }
    }

    private brew_status brew_status_;
}