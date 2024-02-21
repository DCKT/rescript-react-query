module ReactQueryDevtools = {
  type buttonPosition =
    | @as("top-left") TopLeft
    | @as("top-right") TopRight
    | @as("bottom-left") BottomLeft
    | @as("bottom-right") BottomRight
    | @as("relative") Relative

  type position =
    | @as("top") Top
    | @as("bottom") Bottom
    | @as("left") Left
    | @as("right") Right

  @module("@tanstack/react-query-devtools") @react.component
  external make: (
    ~initialIsOpen: bool,
    ~buttonPosition: buttonPosition=?,
    ~position: position=?,
    ~client: ReactQuery__QueryClient.QueryClient.t=?,
  ) => React.element = "ReactQueryDevtools"
}
