import gleam/json
import gleam/result
import gleam/bit_string
import gleam/dynamic.{field, int, string}

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

pub fn from_json(json: String) -> Result(User, UserDecodingError) {
  let decoder =
    dynamic.decode2(User, field("name", of: string), field("age", of: int))

  json.decode(from: json, using: decoder)
  |> result.replace_error(JsonNotValid)
}
