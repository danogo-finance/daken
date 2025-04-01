use aiken/builtin
use aiken/crypto.{ScriptHash, VerificationKeyHash}
use cardano/address.{Address, Inline, VerificationKey}
use cardano/assets.{AssetName, PolicyId, Value}
use cardano/transaction.{InlineDatum, Input, NoDatum, Output, OutputReference}

pub fn new(addr: Address) -> Output {
  Output {
    address: addr,
    value: assets.zero,
    datum: NoDatum,
    reference_script: None,
  }
}

/// Generates input from an output where output reference is generated as below:
/// - tx_hash is blake2b_256 digest of output
/// - output_index is the first byte of tx_hash
pub fn to_input(self: Output) -> Input {
  let tx_hash = self |> builtin.serialise_data |> builtin.blake2b_256
  let output_index = builtin.index_bytearray(tx_hash, 0)
  Input {
    output_reference: OutputReference(tx_hash, output_index),
    output: self,
  }
}

pub fn add_asset(
  self: Output,
  policy_id: PolicyId,
  token_name: AssetName,
  quantity: Int,
) -> Output {
  Output {
    ..self,
    value: self.value |> assets.add(policy_id, token_name, quantity),
  }
}

pub fn add_inline_datum(self: Output, datum: Data) {
  Output { ..self, datum: InlineDatum(datum) }
}

pub fn add_reference_script(self: Output, ref_script: ScriptHash) {
  Output { ..self, reference_script: Some(ref_script) }
}

pub fn add_value(self: Output, other: Value) -> Output {
  Output { ..self, value: assets.merge(self.value, other) }
}

pub fn set_value(self: Output, value: Value) -> Output {
  Output { ..self, value: value }
}

pub fn add_lovelace(self: Output, quantity: Int) -> Output {
  add_asset(self, assets.ada_policy_id, assets.ada_asset_name, quantity)
}

pub fn set_delegation_key(self: Output, vk: VerificationKeyHash) -> Output {
  Output {
    ..self,
    address: Address {
      payment_credential: self.address.payment_credential,
      stake_credential: Some(Inline(VerificationKey(vk))),
    },
  }
}
