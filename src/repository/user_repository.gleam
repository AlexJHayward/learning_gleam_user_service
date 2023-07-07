import model/user.{User}
import gleam/otp/actor
import gleam/result
import gleam/option
import storage/user_actor.{Create as CreateMessage,
  Get as GetMessage, UserActor}

pub type UserServiceError {
  UserDoesNotExist
  UserCreationFailed
}

pub fn get_user(
  storage_actor: UserActor,
  id: String,
) -> Result(User, UserServiceError) {
  actor.call(storage_actor, GetMessage(id, _), 10)
  |> option.to_result(UserDoesNotExist)
}

pub fn create_user(
  storage_actor: UserActor,
  u: User,
) -> Result(String, UserServiceError) {
  actor.call(storage_actor, CreateMessage(u, _), 10)
  |> result.replace_error(UserCreationFailed)
}
