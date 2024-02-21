# rescript-react-query

ReScript bindings for [@tanstack/react-query](https://tanstack.com/query/latest) (targeted version : `^5.22.2`)

## Setup

1. Install the module

```bash
bun install @dck/rescript-react-query
# or
yarn install @dck/rescript-react-query
# or
npm install @dck/rescript-react-query
```

ℹ️ Remember to install `@tanstack/react-query-devtools` module if you want to use `ReactQueryDevtools`.

2. Add it to your `rescript.json` config

```json
{
  "bs-dependencies": ["@dck/rescript-react-query"]
}
```

## Usage

The functions can be accessed through `ReactQuery` module.

### [Simple](https://github.com/DCKT/rescript-react-query/blob/main/examples/src/Simple.res)

### [Basic](https://github.com/DCKT/rescript-react-query/blob/main/examples/src/Basic.res)

### Basic

## Development

Install deps

```bash
bun install
```

Compiles files

```bash
bun run dev
```

Run tests through examples

```bash
bun run examples
```

Run local webserver

```bash
bun run examples-server
```
