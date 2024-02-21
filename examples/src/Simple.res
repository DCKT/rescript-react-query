open! ReactQuery

let queryClient = QueryClient.make()

module Page = {
  type githubData = {
    name: string,
    description: string,
    subscribers_count: int,
    stargazers_count: int,
    forks_count: int,
  }
  @react.component
  let make = () => {
    let {status, error, data, isFetching} = useQuery({
      queryKey: ["repoData"],
      queryFn: _ => Ky.get("https://api.github.com/repos/tannerlinsley/react-query").json(),
    })

    switch status {
    | Pending => <p> {"Loading..."->React.string} </p>
    | Error =>
      <div>
        <p> {"An error occured"->React.string} </p>
        {error->Option.flatMap(e => Js.Exn.message(e))->Option.mapOr(React.null, React.string)}
      </div>
    | Success =>
      <div className="p-4 rounded border inline-flex flex-col m-4">
        <h1> {data.name->React.string} </h1>
        <p> {data.description->React.string} </p>
        <strong> {`👀 ${data.subscribers_count->Int.toString}`->React.string} </strong>
        <strong> {`✨ ${data.stargazers_count->Int.toString}`->React.string} </strong>
        <strong> {`🍴 ${data.forks_count->Int.toString}`->React.string} </strong>
        <div> {isFetching ? "Updating..."->React.string : React.null} </div>
      </div>
    }
  }
}

@react.component
let make = () => {
  <QueryClientProvider client={queryClient}>
    <Page />
    <ReactQueryDevtools initialIsOpen={true} />
  </QueryClientProvider>
}
