# FollowerMaze Solution

This application is responsible for listening to an event source and for
forwarding them to connected clients when appropriate.

## How it works

The application will listen for TCP connections in two ports: `9090` and `9099`.
Clients will connect to `9099` and will start listening to events. The event
source connects to `9090` and starts sending events.

After getting those connections, the application will start forwarding the events
to relevant clients.

## How to run

This application is written in Elixir and uses `mix` to manage dependencies and
to build the app.

First, make sure to have Elixir `1.3+` installed. The installation steps can
be found [here](http://elixir-lang.org/install.html).

After a successful installation, follow the following steps:

  * `$ mix deps.get` to get the dependencies
  * `$ mix run --no-halt`

## The Application Design
