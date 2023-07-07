import gleam/erlang/process
import gleam/http/request
import gleam/map
import gleam/http.{Get, Put}
import mist
import controller/user_controller
import gleam/otp/actor
import storage/user_actor

// TODO first call causes a crash with an assert error, but then subsequent calls are fine?
// TODO Make Id phantom type to have typesafe Id(User) type used everywhere
pub fn main() {
  let assert Ok(actor) = actor.start(map.new(), user_actor.handle_message)
  let assert Ok(_) =
    mist.serve(
      8080,
      mist.handler_func(fn(req) {
        case req.method, request.path_segments(req) {
          Get, ["user"] -> user_controller.get_user(actor, req)
          Put, ["user"] -> user_controller.create_user(actor, req)
        }
      }),
    )

  process.sleep_forever()
}
