module QueryClient = {
  type invalidateQueriesParams = {queryKey: array<string>, exact?: bool}
  type t<'queryData> = {
    invalidateQueries: invalidateQueriesParams => unit,
    getQueryData: array<string> => option<'queryData>,
  }

  type rec queryClientOptions = {defaultOptions?: defaultOptions}
  and defaultOptions = {retryDelay?: int => float}

  @module("@tanstack/react-query") @new
  external make: unit => t<'queryData> = "QueryClient"

  @module("@tanstack/react-query") @new
  external makeWithOptions: queryClientOptions => t<'queryData> = "QueryClient"
}

module QueryClientProvider = {
  @module("@tanstack/react-query") @react.component
  external make: (~client: QueryClient.t<'queryData>, ~children: React.element) => React.element =
    "QueryClientProvider"
}

@module("@tanstack/react-query")
external useQueryClient: unit => QueryClient.t<'queryData> = "useQueryClient"
