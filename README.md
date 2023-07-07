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

## TODO

- [ ] first call causes a crash with an assert error, but then subsequent calls are fine?
- [ ] Make Id phantom type to have typesafe Id(User) type used everywhere

