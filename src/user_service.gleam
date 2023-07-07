import gleam/erlang/process
import gleam/http/request
import gleam/http.{Get, Put}
import mist
import controller/user_controller

pub fn main() {
  let assert Ok(_) =
    mist.serve(
      8080,
      mist.handler_func(fn(req) {
        case req.method, request.path_segments(req) {
          Get, ["user"] -> user_controller.get_user(req)
          Put, ["user"] -> user_controller.create_user(req)
        }
      }),
    )

  process.sleep_forever()
}
