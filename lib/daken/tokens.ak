use aiken/collection/dict
use cardano/assets.{AssetName, PolicyId, Value}
use daken/types.{TupleAsset}

pub fn contains_nft(self: Value, (pid, tn): TupleAsset) {
  assets.quantity_of(self, pid, tn) == 1
}

test contains_nft_1() {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 1)
  contains_nft(v, (pid, tn)) == True
}

test contains_nft_2() {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 0)
  contains_nft(v, (pid, tn)) == False
}

pub fn contains_only_nft(self: Value, (pid, tn): TupleAsset) {
  assets.without_lovelace(self) == assets.from_asset(pid, tn, 1)
}

test contains_only_nft_1() {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 1)
  contains_only_nft(v, (pid, tn)) == True
}

test contains_only_nft_2() {
  let pid = "pid"
  let tn = "tn"
  let v =
    assets.from_asset(pid, tn, 1)
      |> assets.add(assets.ada_policy_id, assets.ada_asset_name, 100)
  contains_only_nft(v, (pid, tn)) == True
}

test contains_only_nft_3() {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 1) |> assets.add("some", "some", 100)
  contains_only_nft(v, (pid, tn)) == False
}

pub fn is_ada(self: TupleAsset) {
  self == (assets.ada_policy_id, assets.ada_asset_name)
}

test is_ada_1() {
  is_ada((assets.ada_policy_id, assets.ada_asset_name)) == True
}

test is_ada_2() {
  is_ada(("some", "some")) == False
}

pub fn get_nft_name(self: Value, pid: PolicyId) -> AssetName {
  when assets.tokens(self, pid) |> dict.to_pairs is {
    [] -> fail @"Not found nft pid"
    [Pair(n, q)] -> {
      expect q == 1
      n
    }
    _ -> fail @"Value must contain only one nft pid"
  }
}

test get_nft_name_1() {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 1)
  get_nft_name(v, pid) == tn
}

test get_nft_name_2() fail {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset("some", tn, 1)
  get_nft_name(v, pid) == tn
}

test get_nft_name_3() fail {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 2)
  get_nft_name(v, pid) == tn
}

test get_nft_name_4() fail {
  let pid = "pid"
  let tn = "tn"
  let v = assets.from_asset(pid, tn, 1) |> assets.add(pid, "some", 1)
  get_nft_name(v, pid) == tn
}
