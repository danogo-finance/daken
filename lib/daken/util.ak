use aiken/builtin
use aiken/collection.{Index}
use aiken/collection/dict
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/primitive/bytearray
use cardano/address.{Address, Script, VerificationKey}
use cardano/assets.{AssetName, PolicyId}
use cardano/script_context.{ScriptContext, Spending}
use cardano/transaction.{
  Datum, DatumHash, InlineDatum, Input, NoDatum, Output, Transaction,
}
use daken/fixture/tx_builder
use daken/flist
use daken/tokens
use daken/types.{Datums, PublicKeyHash, TupleAsset}

pub fn get_spending_input(ctx: ScriptContext) -> Input {
  expect Spending { output: output_reference, .. } = ctx.info
  expect Some(input) =
    list.find(
      ctx.transaction.inputs,
      fn(i) { i.output_reference == output_reference },
    )
  input
}

pub fn get_this_scripts_address(ctx: ScriptContext) -> Address {
  let input = get_spending_input(ctx)
  input.output.address
}

pub fn get_data(datums: Datums, datum: Datum) -> Option<Data> {
  when datum is {
    NoDatum -> None
    DatumHash(h) -> dict.get(datums, h)
    InlineDatum(d) -> Some(d)
  }
}

pub fn get_payment_key(a: Address) -> ByteArray {
  when a.payment_credential is {
    VerificationKey(v) -> v
    Script(s) -> s
  }
}

pub fn must_be_signed_by_key(
  pkhs: List<PublicKeyHash>,
  k: PublicKeyHash,
) -> Bool {
  list.has(pkhs, k)
}

pub fn must_be_signed_by(pkhs: List<PublicKeyHash>, a: Address) -> Bool {
  list.has(
    pkhs,
    when a.payment_credential is {
      VerificationKey(v) -> v
      Script(_) -> fail @"Invalid PublicKeyHash"
    },
  )
}

pub fn get_number_from_hex_string(numstr: ByteArray) -> Int {
  bytearray.foldl(numstr, 0, fn(byte, acc) -> Int { acc * 0x100 + byte })
}

test convert_hex_string_to_int() {
  get_number_from_hex_string(#"887949ab") == 0x887949ab && //
  get_number_from_hex_string(#"") == 0 && //
  get_number_from_hex_string(#"00") == 0
}

/// Convert a integer `n` into some base `q`. This method
/// should scale with any integer and any logical base.
///
/// ```aiken
/// maths.base_q(123, 7)
/// ```
pub fn base_q(n: Int, q: Int) -> List<Int> {
  do_base_q(n, q, [])
}

fn do_base_q(number: Int, base: Int, holder: List<Int>) -> List<Int> {
  // if the number or base is zero return the holder list
  if number == 0 || base == 0 {
    holder
  } else {
    do_base_q(number / base, base, list.push(holder, number % base))
  }
}

pub fn from_int(num: Int, length: Int) -> ByteArray {
  let base_256 = base_q(num, 256)
  let result =
    list.foldr(base_256, #"", fn(n, total) { bytearray.push(total, n) })
  push_by_length(result, length)
}

fn push_by_length(self, length) -> ByteArray {
  if bytearray.length(self) < length {
    push_by_length(bytearray.push(self, 0), length)
  } else {
    self
  }
}

test from_int_1() {
  from_int(23, 2) == #"0017"
}

test from_int_2() {
  from_int(265, 2) == #"0109"
}

pub fn find_while(
  self: List<a>,
  zero: result,
  with: fn(a, result) -> (Bool, result),
) -> result {
  when self is {
    [] -> zero
    [x, ..xs] ->
      when with(x, zero) is {
        (True, r) -> r
        (_, r) -> find_while(xs, r, with)
      }
  }
}

fn found_break_char(b: ByteArray) -> Bool {
  // ["'", "h'", "(", ")", ",", ":", "[", "]", "_", "{", "}"]
  or {
    when bytearray.index_of(b, " ") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "h'") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "'") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "(") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, ")") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, ",") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, ":") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "[") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "]") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "_") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "{") is {
      Some(_) -> True
      _ -> False
    },
    when bytearray.index_of(b, "}") is {
      Some(_) -> True
      _ -> False
    },
  }
}

pub fn data_valid(
  s: ByteArray,
  h: ByteArray,
  b: List<ByteArray>,
  t: ByteArray,
) -> Bool {
  when bytearray.index_of(s, h) is {
    Some((si, e)) ->
      if si == 0 {
        let r =
          find_while(
            b,
            bytearray.drop(s, e + 1),
            fn(p, z) {
              when bytearray.index_of(z, p) is {
                Some((si1, e1)) ->
                  if found_break_char(bytearray.slice(z, 0, si1 - 1)) {
                    (True, z)
                  } else {
                    (False, bytearray.drop(z, e1 + 1))
                  }
                _ -> (True, z)
              }
            },
          )
        let l = bytearray.length(r)
        let i = l - bytearray.length(t)
        and {
          bytearray.slice(r, i, l) == t,
          !found_break_char(bytearray.take(r, i)),
        }
      } else {
        False
      }
    _ -> False
  }
}

pub fn is_burned_nft(tx: Transaction, policy_id: PolicyId, nft_name: ByteArray) {
  (
    tx.mint
      |> assets.quantity_of(policy_id, nft_name)
  ) == -1
}

pub fn find_map(self: List<a>, predicate: fn(a) -> Option<b>) -> Option<b> {
  when self is {
    [] -> None
    [x, ..xs] ->
      when predicate(x) is {
        Some(y) -> Some(y)
        None -> find_map(xs, predicate)
      }
  }
}

pub fn has_valid_nft_license(
  inputs: List<Input>,
  reference_inputs: List<Input>,
  extra_signatories: List<VerificationKeyHash>,
  nft_license_pid: PolicyId,
  nft_license_name: AssetName,
) -> Bool {
  let contain_nft_license =
    fn(
      Input {
        output: Output {
          address: Address { payment_credential: pk, .. },
          value: val,
          ..
        },
        ..
      },
    ) {
      if assets.quantity_of(val, nft_license_pid, nft_license_name) == 1 {
        Some(pk)
      } else {
        None
      }
    }

  // get nft_license in inputs or in reference_inputs
  when find_map(inputs, contain_nft_license) is {
    Some(_) -> True
    None ->
      when find_map(reference_inputs, contain_nft_license) is {
        Some(VerificationKey(vkh)) ->
          // check signatory from the owner of nft_license
          list.has(extra_signatories, vkh)?
        _ -> False
      }
  }
}

pub fn get_datum_by_idx(inputs: List<Input>, nft: TupleAsset, idx: Int) -> Data {
  let Input { output: Output { value, datum, .. }, .. } = flist.get(inputs, idx)
  expect tokens.contains_nft(value, nft)
  expect InlineDatum(datum) = datum
  datum
}

pub fn get_datum_by_nft(inputs: List<Input>, nft: TupleAsset) {
  let found_dt =
    list.find(
      inputs,
      fn(Input { output: Output { value, .. }, .. }) {
        tokens.contains_nft(value, nft)
      },
    )
  expect Some(Input { output: Output { datum: InlineDatum(dt), .. }, .. }) =
    found_dt
  dt
}

pub fn get_maybe_datum_by_nft(
  inputs: List<Input>,
  nft: TupleAsset,
) -> Option<Data> {
  find_map(
    inputs,
    fn(Input { output: Output { value, datum, .. }, .. }) {
      if tokens.contains_nft(value, nft) {
        expect InlineDatum(datum) = datum
        Some(datum)
      } else {
        None
      }
    },
  )
}

pub fn get_list_data_by_idx(
  list_data: List<Data>,
  idx: List<Index>,
) -> List<Data> {
  list.foldr(idx, [], fn(i, ret) { [flist.get(list_data, i), ..ret] })
}

pub fn get_data_in_list_by_idx(data: Data, idx: List<Index>) -> List<Data> {
  let list_data = builtin.un_list_data(data)
  get_list_data_by_idx(list_data, idx)
}

pub fn get_data_in_constr_by_idx(data: Data, idx: List<Index>) -> List<Data> {
  let list_data = builtin.unconstr_fields(data)
  get_list_data_by_idx(list_data, idx)
}

test get_data_in_list_by_idx_1() {
  let data = (1, 2, 3, 4, 5, 6)
  let idxs = [0, 3]
  expect [a, b] = get_data_in_list_by_idx(data, idxs)
  expect a: Int = a
  expect b: Int = b
  and {
    a == 1,
    b == 4,
  }
}

test get_data_in_constr_by_idx_1() {
  let data = tx_builder.new()
  let idxs = [0, 3]
  expect [a, b] = get_data_in_constr_by_idx(data, idxs)
  expect a: List<Input> = a
  expect b: Int = b
  and {
    a == [],
    b == 0,
  }
}
