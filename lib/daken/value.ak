use cardano/assets.{Value}

/// check both value have same assets, excluding lovelace
pub fn same_assets(v1: Value, v2: Value) -> Bool {
  let negated =
    v1
      |> assets.without_lovelace()
      |> assets.negate()
      |> assets.merge(assets.without_lovelace(v2))
  negated == assets.zero
}

test correct_same_assets_1() {
  let v1 =
    assets.from_asset("policy1", "token1", 20)
      |> assets.add("policy2", "token2", 5)
      // add lovelace
      |> assets.add("", "", 400)
  let v2 =
    assets.from_asset("policy2", "token2", 5)
      |> assets.add("policy1", "token1", 20)
      // add lovelace
      |> assets.add("", "", 1000)
  same_assets(v1, v2)
}

test correct_same_assets_2() {
  let v1 =
    assets.from_asset("policy1", "token1", 20)
      |> assets.add("policy2", "token2", 5)
      |> assets.add("policy1", "token3", 1)
  let v2 =
    assets.from_asset("policy2", "token2", 5)
      |> assets.add("policy1", "token1", 20)
  !same_assets(v1, v2)
}

test correct_same_assets_3() {
  let v1 = assets.from_asset("policy1", "token1", 20)
  let v2 =
    assets.from_asset("policy2", "token2", 5)
      |> assets.add("policy1", "token1", 20)
  !same_assets(v1, v2)
}
