import std.stdio;
import std.experimental.logger;

import vibe.d;

import rest.ActuatorRest;
import rest.SensorRest;

void main()
{
	log("Starting teasmade-io REST API");

	auto router = new URLRouter();
	router.registerRestInterface(new SensorRest);
	router.registerRestInterface(new ActuatorRest);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	listenHTTP(settings, router);

	log("Started teasmade-io REST API");
}
