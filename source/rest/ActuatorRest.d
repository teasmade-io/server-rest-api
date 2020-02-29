module rest.ActuatorRest;

import rest.IActuator;

synchronized class ActuatorRest : IActuator
{

    this()
    {
    }

    override int brew(int cups)
    {
        if (brew_status_.done)
        {
            brew_status_.total = cups;
            brew_status_.current = cups;
            while (brew_status_.current > 0)
            {
                import std.conv;
                import std.experimental.logger;
                import core.atomic;
                log("Brewing cup: " ~ to!string(brew_status_.current));
                core.atomic.atomicOp!"-="(this.brew_status_.current, 1);
            }
            brew_status_.done = true;
            return 200; // 200: OK
        } else {
            return 300; // 300: Temporarily Unavailable
        }
    }

    private brew_status brew_status_;
}