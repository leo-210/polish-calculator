import gleam/bool
import gleam/int
import gleam/io
import gleam/iterator.{type Iterator}
import gleam/list
import gleam/result
import gleam/string
import stdin

pub fn main() {
  io.println("Welcome to the reverse polish notation calculator !")

  stdin.stdin()
  |> main_loop([])
}

fn main_loop(it: Iterator(String), stack: List(Int)) -> Iterator(String) {
  io.print("> ")

  let assert Ok(line) = iterator.first(it)

  case line {
    "quit" | "exit" -> it
    _ -> {
      let res = evaluate(line, stack)
      case res {
        Ok(n) -> {
          io.println(int.to_string(n))
          main_loop(it, [n])
        }
        Error(_) -> {
          io.println("Invalid syntax.")
          main_loop(it, [])
        }
      }
    }
  }
}

const digits = "0123456789"

pub fn evaluate(input: String, stack: List(Int)) -> Result(Int, Nil) {
  do_evaluate(input, stack)
}

fn do_evaluate(input: String, stack: List(Int)) -> Result(Int, Nil) {
  use <- bool.guard(
    when: string.is_empty(input),
    return: stack |> pop |> result.map(fn(tuple) { tuple.0 }),
  )

  // The string is not empty, so there is a first character.
  let assert Ok(char) = input |> string.first

  let input = input |> consume

  let is_digit = digits |> string.contains(char)
  case char {
    "+" ->
      stack
      |> do_operation(fn(a, b) { a + b })
      |> result.try(do_evaluate(input, _))
    "-" ->
      stack
      |> do_operation(fn(a, b) { a - b })
      |> result.try(do_evaluate(input, _))
    "*" ->
      stack
      |> do_operation(fn(a, b) { a * b })
      |> result.try(do_evaluate(input, _))
    "/" ->
      stack
      |> do_operation(fn(a, b) { a / b })
      |> result.try(do_evaluate(input, _))
    char if is_digit -> {
      let assert Ok(n) = int.parse(char)
      let #(input, n) = parse_int(input, n)

      stack
      |> put(n)
      |> do_evaluate(input, _)
    }
    _ -> do_evaluate(input, stack)
  }
}

fn do_operation(
  stack: List(Int),
  operation: fn(Int, Int) -> Int,
) -> Result(List(Int), Nil) {
  use #(a, stack) <- result.try(stack |> pop)
  use #(b, stack) <- result.try(stack |> pop)
  stack |> put(operation(a, b)) |> Ok
}

fn parse_int(input: String, n: Int) -> #(String, Int) {
  let res = input |> string.first |> result.try(int.parse)

  case res {
    Ok(next_digit) -> parse_int(input |> consume, 10 * n + next_digit)
    Error(_) -> #(input, n)
  }
}

fn consume(input: String) -> String {
  input |> string.drop_left(1)
}

fn put(on list: List(a), put elem: a) -> List(a) {
  list |> list.prepend(elem)
}

fn pop(list: List(a)) -> Result(#(a, List(a)), Nil) {
  list |> list.pop(fn(_) { True })
}
