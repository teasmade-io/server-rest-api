module rest.ActuatorRest;

import rest.IActuator;

class ActuatorRest : IActuator
{

    this()
    {
    }

    int brew(int cups)
    {
        if (brew_status_.done)
        {
            brew_status_.total = cups;
            brew_status_.current = cups;
            while (brew_status_.current > 0)
            {
                import std.conv;
                import std.experimental.logger;
                log("Brewing cup: " ~ to!string(brew_status_.current));
                brew_status_.current--;
            }
            brew_status_.done = true;
            return 200; // 200: OK
        } else {
            return 300; // 300: Temporarily Unavailable
        }
    }

    brew_status brew_status_;
}