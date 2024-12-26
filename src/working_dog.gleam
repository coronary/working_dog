import gleam/erlang/process
import mist
import wisp.{type Request, type Response}
import wisp/wisp_mist

pub type Context {
  Context(secret: String)
}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    ["sup"] -> wisp.ok()
    _ -> wisp.not_found()
  }
}

pub fn main() {
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(64)
  let assert Ok(_) =
    wisp_mist.handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}
