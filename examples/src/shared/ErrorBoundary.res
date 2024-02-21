type fallbackProps = {
  error: Js.Exn.t,
  resetErrorBoundary: unit => unit,
}

@module("react-error-boundary") @react.component
external make: (
  ~fallback: React.element=?,
  ~fallbackComponent: fallbackProps => React.element=?,
  ~fallbackRender: fallbackProps => React.element=?,
  ~children: React.element,
  ~resetKeys: array<'a>=?,
  ~onError: 'error => unit=?,
) => React.element = "ErrorBoundary"
