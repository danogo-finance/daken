use aiken/builtin
use aiken/collection/list

const l =
  [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
    79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
    98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113,
    114, 115, 116, 117, 118,
  ]

// @TODO: Add tests
/// Gets an element from a list without destructuring more than once
/// If `at` is invalid (negative or out of range), it would fail.
/// This helper can be useful in a narrow scope where performance 
/// is a high priority
pub fn get(self: List<a>, at: Int) -> a {
  advance(self, at) |> builtin.head_list
}

pub fn at(self: List<a>, at: Int) -> a {
  get(self, at)
}

test get_1() {
  at([0, 1, 2, 3], 0) == 0
}

test get_2() {
  at([0, 1, 2, 3], 1) == 1
}

test get_3() {
  at([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10) == 10
}

test get_4() {
  at([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 11) == 11
}

test get_5() {
  at([0, 1, 2, 3, 4, 5, 6], 5) == 5
}

test get_6() {
  at([0, 1, 2, 3, 4, 5, 6], 6) == 6
}

// out of range
test get_7() fail {
  at([0, 1], 2) == 0
}

// negative index
test get_8() fail {
  at([0, 1], -1) == 0
}

// empty array
test get_9() fail {
  at([], 0) == 0
}

pub fn oget(self: List<a>, at: Int) -> Option<a> {
  when advance(self, at) is {
    [] -> None
    [x, ..] -> Some(x)
  }
}

pub fn ato(self: List<a>, at: Int) -> Option<a> {
  oget(self, at)
}

// out of range expect None
test oget_1() {
  ato([0, 1], 2) == None
}

test oget_2() {
  ato([0, 1], 1) == Some(1)
}

// empty array
test oget_3() fail {
  ato([], 0) == Some(0)
}

pub fn get_with_tail(self: List<a>, at: Int) -> (Option<a>, List<a>) {
  when advance(self, at) is {
    [] -> (None, [])
    [x, ..xs] -> (Some(x), xs)
  }
}

test get_with_tail_1() {
  get_with_tail([1, 2, 3, 4], 0) == (Some(1), [2, 3, 4])
}

test get_with_tail_2() {
  get_with_tail([1, 2, 3, 4], 1) == (Some(2), [3, 4])
}

test get_with_tail_3() {
  get_with_tail([1, 2, 3, 4], 3) == (Some(4), [])
}

test get_with_tail_4() {
  get_with_tail(l, 117) == (Some(118), [])
}

test get_with_tail_5() {
  get(l, 117) == 118
}

test get_with_tail_6() {
  oget(l, 117) == Some(118)
}

test get_with_tail_7() {
  list.at(l, 117) == Some(118)
}

test compare_at_list() {
  list.at(l, 117) == Some(118)
}

test compare_at_flist() {
  ato(l, 117) == Some(118)
}

test compare_head_list_1() {
  list.at(l, 0) == Some(1)
}

test compare_head_list_2() {
  list.head(l) == Some(1)
}

test compare_head_flist_1() {
  when l is {
    [] -> 0
    _ -> l |> builtin.head_list
  } == 1
}

test compare_head_flist_2() {
  if builtin.null_list(l) {
    0
  } else {
    l |> builtin.head_list
  } == 1
}

test compare_head_flist_3() {
  if builtin.null_list(l) {
    1 != 1
  } else {
    ( l |> builtin.head_list ) == 1
  }
}

test compare_head_flist_4() {
  ( l |> builtin.head_list ) == 1
}

test compare_head_flist_5() {
  builtin.choose_list(l, 0, builtin.head_list(l)) == 1
}

pub fn take(self: List<a>, n: Int) -> List<a> {
  do_take(self, n)
}

fn do_take(self: List<a>, n: Int) -> List<a> {
  if n > 0 {
    [self |> builtin.head_list, ..do_take(self |> builtin.tail_list, n - 1)]
  } else {
    []
  }
}

test take_list_1() {
  list.take(l, 58) == [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
  ]
}

test take_list_2() {
  list.take(l, 6) == [1, 2, 3, 4, 5, 6]
}

test take_flist_1() {
  take(l, 58) == [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
  ]
}

test take_flist_2() {
  take(l, 6) == [1, 2, 3, 4, 5, 6]
}

pub fn take_with_remain(self: List<a>, n: Int) -> (List<a>, List<a>) {
  do_take_with_remain(self, n)
}

fn do_take_with_remain(self: List<a>, n: Int) -> (List<a>, List<a>) {
  if n > 0 {
    let (t, r) = do_take_with_remain(self |> builtin.tail_list, n - 1)
    ([self |> builtin.head_list, ..t], r)
  } else {
    ([], self)
  }
}

test take_flist_remain_1() {
  let (h, _t) = take_with_remain(l, 58)
  // trace h
  // trace t
  h == [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
  ]
}

test take_flist_remain_2() {
  let (h, _) = take_with_remain(l, 6)
  h == [1, 2, 3, 4, 5, 6]
}

test take_flist_remain_get_1() {
  let idx = 57
  let (_i, _t) = get_with_tail(l, idx)
  let h = take(l, idx + 1)
  // trace h
  // trace t
  h == [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
  ]
}

test take_flist_remain_get_2() {
  let idx = 5
  let (_i, _t) = get_with_tail(l, idx)
  let h = take(l, idx + 1)
  // trace h
  // trace t
  h == [1, 2, 3, 4, 5, 6]
}

pub fn take_reverse(self: List<a>, n: Int) -> List<a> {
  do_take_reverse(self, n, [])
}

fn do_take_reverse(self: List<a>, n: Int, zero: List<a>) -> List<a> {
  if n > 0 {
    do_take_reverse(
      self |> builtin.tail_list,
      n - 1,
      [self |> builtin.head_list, ..zero],
    )
  } else {
    zero
  }
}

test take_flist_reverse_1() {
  take_reverse(l, 58) == [
    58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40,
    39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21,
    20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1,
  ]
}

test take_flist_reverse_2() {
  take_reverse(l, 6) == [6, 5, 4, 3, 2, 1]
}

pub fn advance(self: List<a>, idx: Int) -> List<a> {
  if idx == 0 {
    self
  } else if idx < 3 {
    self
      |> builtin.tail_list
      |> advance(idx - 1)
  } else if idx >= 10 {
    self
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> advance(idx - 10)
  } else if idx >= 5 {
    self
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> advance(idx - 5)
  } else {
    self
      |> builtin.tail_list
      |> builtin.tail_list
      |> builtin.tail_list
      |> advance(idx - 3)
  }
}

fn advance_step_by_step(self: List<a>, idx: Int) -> List<a> {
  if idx == 0 {
    self
  } else {
    self |> builtin.tail_list |> advance_step_by_step(idx - 1)
  }
}

test fail_when_advance_empty_list() fail {
  builtin.tail_list([]) == []
}

test take_head_flist_head_list_builtin() {
  let idx = 0
  if idx == 0 {
    builtin.head_list(l) == 1
  } else {
    False
  }
}

test take_head_list_head() {
  list.head(l) == Some(1)
}

test take_head_list_at() {
  let idx = 0
  list.at(l, idx) == Some(1)
}

test take_head_list_take() {
  let idx = 0
  list.take(l, idx + 1) == [1]
}

test take_head_flist_take() {
  let idx = 0
  take(l, idx + 1) == [1]
}

test take_head_flist_get_with_tail() {
  let (i, _t) = get_with_tail(l, 0)
  i == Some(1)
}

test take_head_flist_get() {
  get(l, 0) == 1
}

test take_head_flist_at() {
  at(l, 0) == 1
}

test take_head_flist_oget() {
  oget(l, 0) == Some(1)
}

test take_head_flist_ato() {
  ato(l, 0) == Some(1)
}

pub fn foldl2(
  self: List<elem>,
  zero_a: a,
  zero_b: b,
  with: fn(elem, a, b, fn(a, b) -> result) -> result,
  return: fn(a, b) -> result,
) -> result {
  when self is {
    [] -> return(zero_a, zero_b)
    [x, ..xs] -> {
      let a, b <- with(x, zero_a, zero_b)
      foldl2(xs, a, b, with, return)
    }
  }
}

test test_foldl2() {
  let
    sum,
    product,
  <-
    foldl2(
      [1, 2, 3, 4, 5],
      0,
      1,
      fn(item, sum, product, return) { return(sum + item, product * item) },
    )
  and {
    sum == 15,
    product == 120,
  }
}

pub fn foldl3(
  self: List<elem>,
  zero_a: a,
  zero_b: b,
  zero_c: c,
  with: fn(elem, a, b, c, fn(a, b, c) -> result) -> result,
  return: fn(a, b, c) -> result,
) -> result {
  when self is {
    [] -> return(zero_a, zero_b, zero_c)
    [x, ..xs] -> {
      let a, b, c <- with(x, zero_a, zero_b, zero_c)
      foldl3(xs, a, b, c, with, return)
    }
  }
}

test test_foldl3() {
  let
    sum,
    product,
    sum_square,
  <-
    foldl3(
      [1, 2, 3, 4, 5],
      0,
      1,
      0,
      fn(item, sum, product, sum_square, return) {
        return(sum + item, product * item, sum_square + item * item)
      },
    )
  and {
    sum == 15,
    product == 120,
    sum_square == 55,
  }
}
