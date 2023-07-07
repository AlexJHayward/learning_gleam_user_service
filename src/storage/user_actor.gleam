import model/user.{User}
import model/id
import gleam/option.{Option}
import gleam/map.{Map}
import gleam/otp/actor
import model/uuid
import gleam/erlang/process.{Subject}

pub type UserActor =
  Subject(UserMessage)

type UserStore =
  Map(String, User)

pub type UserMessage {
  Shutdown

  Create(user: User, reply_with: Subject(Result(String, Nil)))

  Get(id: String, reply_with: Subject(Option(User)))
}

pub fn handle_message(
  message: UserMessage,
  users: UserStore,
) -> actor.Next(UserStore) {
  case message {
    Shutdown -> actor.Stop(process.Normal)

    Create(user, client) -> {
      let id = uuid.new()

      let new_state =
        users
        |> map.insert(id, user)

      process.send(client, Ok(id))
      actor.Continue(new_state)
    }

    Get(id, client) -> {
      let maybe_user =
        users
        |> map.get(id)
        |> option.from_result()

      process.send(client, maybe_user)
      actor.Continue(users)
    }
  }
}
