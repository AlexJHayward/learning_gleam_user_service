# user_service

A simple project to learn about gleam!

## usage

```
> gleam run

> curl -H 'Content-Type: application/json' -X PUT -d '{"name": "Gandalf", "age": 24000}' localhost:8080/user
8bd47936-3f45-4c85-b127-096e0348c43d

> curl 'localhost:8080/user?id=8bd47936-3f45-4c85-b127-096e0348c43d'
{"name": "Gandalf", "age": 24000}
```

## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add user_service
```

and its documentation can be found at <https://hexdocs.pm/user_service>.
