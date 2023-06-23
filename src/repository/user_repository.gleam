import model/user.{User}

pub type UserServiceError {
  UserDoesNotExist
  UserCreationFailed
}

pub fn get_user(id: String) -> Result(User, UserServiceError) {
  case id {
    "1" -> Ok(User("Gandalf", 24_000))
    _ -> Error(UserDoesNotExist)
  }
}

pub fn create_user(u: User) -> Result(String, UserServiceError) {
  Ok("2")
}
