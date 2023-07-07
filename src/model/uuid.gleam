import ids/uuid

pub fn new() -> String {
  let assert Ok(id) = uuid.generate_v4()
  id
}
