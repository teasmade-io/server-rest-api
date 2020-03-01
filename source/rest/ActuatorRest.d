module rest.ActuatorRest;

import std.concurrency;
import std.datetime;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart;

import rest.IActuator;

class ActuatorRest : IActuator
{

    this()
    {
    }

    override int brew() @trusted
    {
        if (brew_status_.sw == null || seconds_since_brew() > 30)
        {
            brew_status_.sw = new StopWatch(AutoStart.yes);
            serial_thread.send("B\r\n");
            return 200; // 200: OK
        } else {
            return 300; // 300: Temporarily Unavailable
        }
    }

    override long seconds_since_brew() @safe
    {
        if (brew_status_.sw == null) 
        {
            return -1000000;
        }
        else {
            return brew_status_.sw.peek().total!"seconds";
        }
    }

    private brew_status brew_status_;
    public Tid serial_thread;
}