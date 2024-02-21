@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <React.Fragment>
    <nav className="flex flex-row gap-4 items-center bg-white mb-4 shadow p-4">
      <a href="/" className="text-blue-500 underline"> {"Simple"->React.string} </a>
      <a href="/basic" className="text-blue-500 underline"> {"Basic"->React.string} </a>
    </nav>
    {switch url.path {
    | list{} => <Simple />
    | list{"basic"} => <Basic />

    | _ => <p> {"Page not found"->React.string} </p>
    }}
  </React.Fragment>
}
