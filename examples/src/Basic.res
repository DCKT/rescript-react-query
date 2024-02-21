open! ReactQuery

let queryClient = QueryClient.make()

type post = {
  id: int,
  title: string,
  body: string,
}

module Post = {
  let usePost = postId => {
    useQuery({
      queryKey: ["post", postId->Int.toString],
      queryFn: (_): promise<post> =>
        Ky.get(`https://jsonplaceholder.typicode.com/posts/${postId->Int.toString}`).json(),
      enabled: postId !== 0,
    })
  }

  @react.component
  let make = (~setPostId, ~postId: int) => {
    let {status, error, data, isFetching} = usePost(postId)

    <article>
      <div className="flex flex-row gap-6">
        <a onClick={_ => setPostId(_ => -1)} className="text-blue-600 text-lg underline" href="#">
          {"Back"->React.string}
        </a>
        {isFetching && status === Success
          ? <p className="text-red-700 font-semibold"> {"Background Updating..."->React.string} </p>
          : React.null}
      </div>
      {switch status {
      | Pending => <p> {"Loading..."->React.string} </p>
      | Error =>
        <div>
          <p> {"An error occured"->React.string} </p>
          {error->Option.flatMap(e => Js.Exn.message(e))->Option.mapOr(React.null, React.string)}
        </div>
      | Success =>
        <div>
          <h1> {data.title->React.string} </h1>
          <div>
            <p> {data.body->React.string} </p>
          </div>
        </div>
      }}
    </article>
  }
}

module Posts = {
  let usePosts = () => {
    useQuery({
      queryKey: ["posts"],
      queryFn: (_): promise<array<post>> =>
        Ky.get("https://jsonplaceholder.typicode.com/posts").json(),
    })
  }

  @react.component
  let make = (~setPostId) => {
    let queryClient = useQueryClient()
    let {status, error, data, isFetching} = usePosts()

    switch status {
    | Pending => <p> {"Loading..."->React.string} </p>
    | Error =>
      <div>
        <p> {"An error occured"->React.string} </p>
        {error->Option.flatMap(e => Js.Exn.message(e))->Option.mapOr(React.null, React.string)}
      </div>
    | Success =>
      <div className="">
        <h1> {"Posts"->React.string} </h1>
        {data
        ->Array.map(post => {
          <p key={post.id->Int.toString}>
            <a
              onClick={_ => setPostId(_ => post.id)}
              href="#"
              className={
                // We can access the query data here to show bold links for
                // ones that are cached
                queryClient
                ->QueryClient.getQueryData(["post", post.id->Int.toString])
                ->Option.isSome
                  ? "font-bold text-green-700"
                  : ""
              }>
              {post.title->React.string}
            </a>
          </p>
        })
        ->React.array}
        <div> {isFetching ? "Background Updating..."->React.string : React.null} </div>
      </div>
    }
  }
}

@react.component
let make = () => {
  let (postId, setPostId) = React.useState(() => -1)
  <QueryClientProvider client={queryClient}>
    <div className="p-4">
      <section className="mb-4 pb-4 border-b-2">
        <p>
          {"As you visit the posts below, you will notice them in a loading state
        the first time you load them. However, after you return to this list and
        click on any posts you have already visited again, you will see them
        load instantly and background refresh right before your eyes!"->React.string}
        </p>
        <strong>
          {"(You may need to throttle your network speed to simulate longer
          loading sequences)"->React.string}
        </strong>
      </section>
      {postId > -1 ? <Post postId={postId} setPostId={setPostId} /> : <Posts setPostId />}
      <ReactQueryDevtools initialIsOpen={true} position={Right} />
    </div>
  </QueryClientProvider>
}
