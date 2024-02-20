open RescriptCore
open RescriptBun
open RescriptBun.Globals
open Test

let wait = ms => {
  Promise.make((resolve, _) => setTimeout(() => resolve(), ms)->ignore)
}

test("demo", () => {
  expect(1)->Expect.toBe(1)
})
