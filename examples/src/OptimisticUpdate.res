open! ReactQuery

let queryClient = QueryClient.make()

module Page = {
  type api = {counter: int}
  @react.component
  let make = () => {
    let queryClient = useQueryClient()
    let {status, error, data} = useQuery({
      queryKey: ["counter"],
      queryFn: _ => Ky.get("http://localhost:3000", ~options={timeout: 2000, retry: Int(0)}).json(),
    })

    let increaseMutation = useMutation({
      mutationFn: () => Ky.post("http://localhost:3000/increase").json(),
      onSettled: () => queryClient.invalidateQueries({queryKey: ["counter"]}),
    })

    let decreaseMutation = useMutation({
      mutationFn: () => Ky.post("http://localhost:3000/decrease").json(),
      onSettled: () => queryClient.invalidateQueries({queryKey: ["counter"]}),
    })

    let counterIsPending = decreaseMutation.isPending || increaseMutation.isPending

    <div className="p-4">
      {switch status {
      | Pending => <p> {"Loading..."->React.string} </p>
      | Error =>
        <div>
          <p className="text-red-600"> {"An error occured, reason: "->React.string} </p>
          {error->Option.flatMap(e => Js.Exn.message(e))->Option.mapOr(React.null, React.string)}
        </div>
      | Success =>
        <React.Fragment>
          <div className="p-4 rounded border inline-flex flex-row items-center gap-4">
            <p> {"Counter"->React.string} </p>
            <p className="text-xl font-semibold"> {data.counter->React.int} </p>
            {counterIsPending ? <Loader className="text-purple-800" /> : React.null}
          </div>
          <div className="flex flex-row items-center gap-2 mt-4">
            <button
              disabled={counterIsPending}
              onClick={_ => decreaseMutation.mutate()}
              className="inline-flex flex-row items-center gap-2 border border-purple-400 bg-purple-100 text-purple-800 rounded px-2 py-1 shadow shadow-purple-400 disabled:opacity-50">
              {"Decrease (no delay)"->React.string}
            </button>
            <button
              disabled={counterIsPending}
              onClick={_ => increaseMutation.mutate()}
              className="inline-flex flex-row items-center gap-2 border border-purple-400 bg-purple-100 text-purple-800 rounded px-2 py-1 shadow shadow-purple-400 disabled:opacity-50">
              {"Increase (delay 2 seconds)"->React.string}
            </button>
          </div>
        </React.Fragment>
      }}
    </div>
  }
}

@react.component
let make = () => {
  <QueryClientProvider client={queryClient}>
    <Page />
    <ReactQueryDevtools initialIsOpen={true} position={Right} />
  </QueryClientProvider>
}
