include ReactQuery__QueryClient
include ReactQuery__QueryDevtools

@module("@tanstack/react-query")
external keepPreviousData: 'a = "keepPreviousData"

type networkMode =
  | @as("online") Online
  | @as("always") Always
  | @as("offlineFirst") OfflineFirst

@unboxed
type placeholderData<'data> =
  | Data('data)
  | Function

@unboxed
type retry =
  | Bool(bool)
  | Int(int)
  | Function(int => bool)
@unboxed
type retryDelay =
  | Int(int)
  | Function(int => float)

type abortSignal
type queryFnParams = {signal: abortSignal}

type queryOptions<'data> = {
  queryKey: array<string>,
  queryFn: queryFnParams => promise<'data>,
  staleTime?: int,
  retry?: retry,
  retryDelay?: retryDelay,
  networkMode?: networkMode,
  enabled?: bool,
  refetchOnWindowFocus?: bool,
  initialData?: 'data,
}

type useQueryOptions<'data> = {
  ...queryOptions<'data>,
  placeholderData?: 'data,
}

type queryOptionsWithSelect<'data, 'selectedData> = {
  ...useQueryOptions<'data>,
  select: 'data => 'selectedData,
}

type status =
  | @as("pending") Pending
  | @as("error") Error
  | @as("success") Success

type fetchStatus =
  | @as("fetching") Fetching
  | @as("paused") Paused
  | @as("idle") Idle

type rec queryState<'data> = {
  isPending: bool,
  isError: bool,
  isSuccess: bool,
  isFetching: bool,
  status: status,
  fetchStatus: status,
  data: 'data,
  error: option<Js.Exn.t>,
  refetch: unit => promise<queryState<'data>>,
}

type useQueriesOptions<'data> = {queries: array<queryOptions<'data>>}

@module("@tanstack/react-query")
external useQuery: useQueryOptions<'data> => queryState<'data> = "useQuery"
@module("@tanstack/react-query")
external useSuspenseQuery: queryOptions<'data> => queryState<'data> = "useSuspenseQuery"

@module("@tanstack/react-query")
external useQueryWithSelect: queryOptionsWithSelect<'data, 'selectedData> => queryState<
  'selectedData,
> = "useQuery"

@module("@tanstack/react-query")
external useQueries: useQueriesOptions<'data> => array<queryState<'data>> = "useQueries"

type useMutationOptions<'params, 'data, 'error, 'context> = {
  mutationFn: 'params => promise<'data>,
  retry?: retry,
  retryDelay?: retryDelay,
  onMutate?: 'params => promise<'context>,
  onError?: ('error, 'params, 'context) => unit,
  onSuccess?: ('data, 'params, 'context) => unit,
  onSettled?: ('data, 'error, 'params, 'context) => unit,
}
type mutationStatus =
  | @as("error") Error
  | @as("pending") Pending
  | @as("idle") Idle
  | @as("success") Success

type mutationState<'params, 'data, 'error, 'context> = {
  isPending: bool,
  isError: bool,
  isSuccess: bool,
  isFetching: bool,
  status: mutationStatus,
  reset: unit => unit,
  onError: ('error, 'params, 'context) => unit,
  onSuccess: ('data, 'params, 'context) => unit,
  onSettled: ('data, 'error, 'params, 'context) => unit,
  mutate: 'params => unit,
  mutateAsync: 'params => promise<'data>,
}
@module("@tanstack/react-query")
external useMutation: useMutationOptions<'params, 'data, 'error, 'context> => mutationState<
  'params,
  'data,
  'error,
  'context,
> = "useMutation"

module QueryErrorResetBoundary = {
  type renderProps = {reset: unit => unit}

  @module("@tanstack/react-query") @react.component
  external make: (~children: renderProps => React.element) => React.element =
    "QueryErrorResetBoundary"
}

@module("@tanstack/react-query")
external useQueryErrorResetBoundary: unit => QueryErrorResetBoundary.renderProps =
  "useQueryErrorResetBoundary"
