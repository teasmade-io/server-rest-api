module rest.IActuator;

import std.datetime;
import std.datetime.stopwatch : benchmark, StopWatch;

import vibe.d;

interface IActuator
{
    struct brew_status {
        StopWatch* sw;
    }

    @path("/api/v1/brew")
    @method(HTTPMethod.POST)
    int brew() @safe;

    @path("/api/v1/brew/time")
    long seconds_since_brew() @safe;
}