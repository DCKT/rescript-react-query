# rescript-<module>

ReScript bindings for [<module>](https://github.com/X/Y) (targeted version : `~X.X.X`)

## Setup

1. Install the module

```bash
bun install @dck/rescript-<module>
# or
yarn install @dck/rescript-<module>
# or
npm install @dck/rescript-<module>
```

2. Add it to your `rescript.json` config

```json
{
  "bsc-dependencies": ["@dck/rescript-<module>"]
}
```

## Usage

The functions can be accessed through `X` module.

## Development

Install deps

```bash
bun install
```

Compiles files

```bash
bun run dev
```

Run tests

```bash
bun test
```
