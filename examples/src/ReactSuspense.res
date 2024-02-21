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
    let {data} = useSuspenseQuery({
      queryKey: ["repoData"],
      queryFn: _ => Ky.get("https://api.github.com/repos/tannerlinsley/react-query").json(),
    })

    <div className="p-4 rounded border inline-flex flex-col">
      <h1> {data.name->React.string} </h1>
      <p> {data.description->React.string} </p>
      <strong> {`👀 ${data.subscribers_count->Int.toString}`->React.string} </strong>
      <strong> {`✨ ${data.stargazers_count->Int.toString}`->React.string} </strong>
      <strong> {`🍴 ${data.forks_count->Int.toString}`->React.string} </strong>
    </div>
  }
}

module RenderFailure = {
  type githubData = {
    name: string,
    description: string,
    subscribers_count: int,
    stargazers_count: int,
    forks_count: int,
  }
  @react.component
  let make = () => {
    let _ = useSuspenseQuery({
      queryKey: ["error"],
      retry: Int(0),
      queryFn: _ =>
        Ky.get("http://localhost:3000/error", ~options={timeout: 1000, retry: Int(0)}).json(),
    })

    <div className="flex flex-row items-center gap-2">
      {"OK ! (restart the server & refresh to retest)"->React.string}
    </div>
  }
}

@react.component
let make = () => {
  <div className="p-4">
    <QueryClientProvider client={queryClient}>
      <React.Suspense fallback={<Loader className="text-slate-900" />}>
        <Page />
      </React.Suspense>
      <div className="mt-4">
        <QueryErrorResetBoundary>
          {({reset}) => {
            <ErrorBoundary
              fallbackRender={({resetErrorBoundary}) => {
                <div
                  className="border border-red-500 p-1 rounded text-red-700 flex flex-row items-center gap-2">
                  {"Oups ! Something went wrong 🫠"->React.string}
                  <button
                    className="ml-2 border px-2 py-1"
                    onClick={_ => {
                      reset()
                      resetErrorBoundary()
                    }}>
                    {"Retry"->React.string}
                  </button>
                </div>
              }}>
              <React.Suspense fallback={<Loader className="text-slate-900" />}>
                <RenderFailure />
              </React.Suspense>
            </ErrorBoundary>
          }}
        </QueryErrorResetBoundary>
      </div>
      <ReactQueryDevtools initialIsOpen={true} />
    </QueryClientProvider>
  </div>
}
