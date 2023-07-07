import gleam/json
import gleam/result
import gleam/bit_string
import gleam/dynamic

pub type User {
  User(name: String, age: Int)
}

pub type UserDecodingError {
  BitStringNotValid
  JsonNotValid
}

pub fn from_bit_string(json: BitString) -> Result(User, UserDecodingError) {
  bit_string.to_string(json)
  |> result.replace_error(BitStringNotValid)
  |> result.then(from_json(_))
}

pub fn from_json(json_string: String) -> Result(User, UserDecodingError) {
  let decoder =
    dynamic.decode2(
      User,
      dynamic.field("name", of: dynamic.string),
      dynamic.field("age", of: dynamic.int),
    )

  json.decode(from: json_string, using: decoder)
  |> result.replace_error(JsonNotValid)
}

pub fn to_json(user: User) -> String {
  json.object([#("name", json.string(user.name)), #("age", json.int(user.age))])
  |> json.to_string
}
