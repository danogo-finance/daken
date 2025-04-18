pub fn extract(self: Pairs<k, v>, key: k) -> (Option<v>, Pairs<k, v>) {
  when self is {
    [] -> (None, self)
    [Pair(x_k, x_v) as x, ..xs] ->
      if x_k == key {
        (Some(x_v), xs)
      } else {
        let (result, excluded) = extract(xs, key)
        (result, [x, ..excluded])
      }
  }
}

test extract_1() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  extract(p, "a") == (Some(1), [Pair("b", 2), Pair("c", 3)])
}

test extract_2() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  extract(p, "b") == (Some(2), [Pair("a", 1), Pair("c", 3)])
}

test extract_3() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  extract(p, "c") == (Some(3), [Pair("a", 1), Pair("b", 2)])
}

test extract_4() {
  let p = []
  extract(p, "c") == (None, p)
}

test extract_5() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  extract(p, "d") == (None, p)
}

pub fn get_first(self: Pairs<key, value>, key k: key) -> value {
  when self is {
    [] -> fail @"Key not found"
    [Pair(k2, v), ..rest] ->
      if k == k2 {
        v
      } else {
        get_first(rest, k)
      }
  }
}

test get_first_1() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  get_first(p, "a") == 1
}

test get_first_2() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  get_first(p, "b") == 2
}

test get_first_3() {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  get_first(p, "c") == 3
}

test get_first_4() fail {
  let p = []
  get_first(p, "c") == 3
}

test get_first_5() fail {
  let p = [Pair("a", 1), Pair("b", 2), Pair("c", 3)]
  get_first(p, "d") == 3
}
