module QueryClient = {
  type queryKey = array<string>
  type queryOptions = {queryKey: queryKey, exact?: bool}

  type t

  type rec queryClientOptions = {defaultOptions?: defaultOptions}
  and defaultOptions = {retryDelay?: int => float}

  @module("@tanstack/react-query") @new
  external make: unit => t = "QueryClient"

  @module("@tanstack/react-query") @new
  external makeWithOptions: queryClientOptions => t = "QueryClient"

  @send
  external invalidateQueries: (t, queryOptions) => unit = "invalidateQueries"
  @send
  external getQueryData: (t, queryKey) => option<'queryData> = "getQueryData"
  @send
  external cancelQueries: (t, queryOptions) => promise<unit> = "cancelQueries"
  @send
  external setQueryData: (t, queryKey, 'queryData) => unit = "setQueryData"
}

module QueryClientProvider = {
  @module("@tanstack/react-query") @react.component
  external make: (~client: QueryClient.t, ~children: React.element) => React.element =
    "QueryClientProvider"
}

@module("@tanstack/react-query")
external useQueryClient: unit => QueryClient.t = "useQueryClient"
