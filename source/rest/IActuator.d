module rest.IActuator;

import vibe.d;

synchronized interface IActuator
{
    struct brew_status {
        int total;
        int current;
        bool done = true;
    }

    /* 
    Post data as:
        { "brew": "2" }
    */
    @path("/api/v1/brew")
    @method(HTTPMethod.POST)
    int brew(int cups);
}