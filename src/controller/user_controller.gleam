import gleam/bit_builder
import gleam/http/response
import gleam/http/request.{Request}
import mist
import repository/user_repository
import gleam/map
import gleam/result
import model/user
import storage/user_actor.{UserActor}

type RequestError {
  IdParamMissing
  NotFound
  InternalError
  RequestBodyCouldNotBeDecoded
}

pub fn get_user(storage_actor: UserActor, req: Request(a)) -> mist.Response {
  let id: Result(String, RequestError) =
    req
    |> request.get_query()
    |> result.map(fn(params) { map.from_list(params) })
    |> result.then(map.get(_, "id"))
    |> result.replace_error(IdParamMissing)

  let #(status, body_string): #(Int, String) = case
    id
    |> result.then(fn(id) {
      user_repository.get_user(storage_actor, id)
      |> result.replace_error(NotFound)
    })
  {
    Ok(user) -> #(200, user.to_json(user))
    Error(NotFound) -> #(404, "user not found")
    Error(IdParamMissing) -> #(400, "no user id provided")
  }

  response.new(status)
  |> mist.bit_builder_response(bit_builder.from_string(body_string))
}

pub fn create_user(
  storage_actor: UserActor,
  req: Request(mist.Body),
) -> mist.Response {
  let user =
    mist.read_body(req)
    |> result.replace_error(RequestBodyCouldNotBeDecoded)
    |> result.map(fn(body) { body.body })
    |> result.then(fn(b_string) {
      user.from_bit_string(b_string)
      |> result.replace_error(RequestBodyCouldNotBeDecoded)
    })

  let #(status, response_message): #(Int, String) = case
    user
    |> result.then(fn(user) {
      user_repository.create_user(storage_actor, user)
      |> result.replace_error(InternalError)
    })
  {
    Ok(id) -> #(201, id)
    Error(InternalError) -> #(500, "failed to create the user record")
    Error(RequestBodyCouldNotBeDecoded) -> #(
      400,
      "the request body could not be decoded",
    )
  }
  response.new(status)
  |> mist.bit_builder_response(bit_builder.from_string(response_message))
}
