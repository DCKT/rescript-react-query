open RescriptBun
open RescriptBun.Globals

let counter = ref(0)

let corsHeaders = [
  ("Access-Control-Allow-Origin", "*"),
  ("Access-Control-Allow-Methods", "OPTIONS, POST, DELETE"),
  ("Access-Control-Allow-Headers", "Content-Type, Authorization"),
]

let wait = ms => {
  Promise.make((resolve, _) => setTimeout(() => resolve(), ms)->ignore)
}

let firstAttemptError = ref(true)

@val
external jsonResponse: (
  'a,
  ~options: RescriptBun.Globals.Response.responseInit=?,
) => RescriptBun.Globals.Response.t = "Response.json"

let server = Bun.serve({
  fetch: async (request, _server) => {
    let url = URL.make(request->Globals.Request.url)
    switch url->Globals.URL.pathname {
    | "/" => jsonResponse({"counter": counter.contents}, ~options={headers: FromArray(corsHeaders)})
    | "/increase" => {
        counter := counter.contents + 1
        await wait(2000)
        jsonResponse({"counter": counter.contents}, ~options={headers: FromArray(corsHeaders)})
      }
    | "/increase-error" => {
        await wait(1000)
        jsonResponse(None, ~options={status: 500, headers: FromArray(corsHeaders)})
      }
    | "/decrease" => {
        counter := counter.contents - 1
        jsonResponse({"counter": counter.contents}, ~options={headers: FromArray(corsHeaders)})
      }
    | "/error" => {
        let status = firstAttemptError.contents ? 500 : 200
        firstAttemptError := false
        jsonResponse(None, ~options={status, headers: FromArray(corsHeaders)})
      }

    | _ =>
      jsonResponse(
        `404`,
        ~options={
          status: 404,
        },
      )
    }
  },
})

Console.log(`HTTP server launched on localhost:${server->Bun.Server.port->Int.toString}`)
