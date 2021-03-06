module rest.ActuatorRest;

import std.concurrency;
import std.datetime;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart;

import rest.IActuator;
import vibe.d : HTTPStatusException;

class ActuatorRest : IActuator
{

    this()
    {
    }

    override void brew() @trusted
    {
        if (brew_status_.sw == null || seconds_since_brew() > 0)
        {
            brew_status_.sw = new StopWatch(AutoStart.yes);
            serial_thread.send("B\r\n");
            // 200 OK
        } else {
            throw new HTTPStatusException(300);
        }
    }

    override long seconds_since_brew() @safe
    {
        if (brew_status_.sw == null) 
        {
            return -1000000;
        }
        else {
            return (brew_status_.sw.peek().total!"seconds") - 35;
        }
    }

    private brew_status brew_status_;
    public Tid serial_thread;
}