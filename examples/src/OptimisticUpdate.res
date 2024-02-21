open! ReactQuery

let queryClient = QueryClient.make()

module Page = {
  type api = {counter: int}

  let queryKey = ["counter"]

  @react.component
  let make = () => {
    let queryClient = useQueryClient()
    let {status, error, data} = useQuery({
      queryKey,
      queryFn: _ => Ky.get("http://localhost:3000", ~options={timeout: 2000, retry: Int(0)}).json(),
    })

    let increaseMutationWithError = useMutation({
      mutationFn: () => Ky.post("http://localhost:3000/increase-error").json(),
      onSettled: (_, _, _, _) => queryClient->QueryClient.invalidateQueries({queryKey: queryKey}),
      onMutate: async _ => {
        // Cancel any outgoing refetch
        // (so they don't overwrite our optimistic update)
        await queryClient->QueryClient.cancelQueries({queryKey: queryKey})

        // Snapshot the previous value
        let previousCount: option<api> = queryClient->QueryClient.getQueryData(queryKey)

        // Optimistically update to the new value
        previousCount->Option.forEach(({counter}) => {
          queryClient->QueryClient.setQueryData(queryKey, {counter: counter + 1})
        })

        previousCount
      },
      // If the mutation fails,
      // use the context returned from onMutate to roll back
      onError: (_err, _variables, context) => {
        context->Option.forEach(previousCount => {
          queryClient->QueryClient.setQueryData(queryKey, previousCount)
        })
      },
    })

    let increaseMutation = useMutation({
      mutationFn: () => Ky.post("http://localhost:3000/increase").json(),
      onSettled: (_, _, _, _) =>
        queryClient->QueryClient.invalidateQueries({queryKey: ["counter"]}),
    })

    let decreaseMutation = useMutation({
      mutationFn: () => Ky.post("http://localhost:3000/decrease").json(),
      onSettled: (_, _, _, _) =>
        queryClient->QueryClient.invalidateQueries({queryKey: ["counter"]}),
    })

    let counterIsPending =
      decreaseMutation.isPending ||
      increaseMutation.isPending ||
      increaseMutationWithError.isPending

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
            <button
              disabled={counterIsPending}
              onClick={_ => increaseMutationWithError.mutate()}
              className="inline-flex flex-row items-center gap-2 border border-purple-400 bg-purple-100 text-purple-800 rounded px-2 py-1 shadow shadow-purple-400 disabled:opacity-50">
              {"Increase (with error)"->React.string}
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
