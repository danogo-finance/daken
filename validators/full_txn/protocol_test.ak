// success_only_mint_protocol_nft
// success_mint_all_nft
// fail_only_mint_license_nft
// fail_mint_invalid_name_protocol_nft
// fail_mint_invalid_name_license_nft
// fail_mint_invalid_quantity_protocol_nft
// fail_mint_invalid_quantity_license_nft
// fail_mint_nft_name_is_empty

use aiken/crypto
use cardano/address.{Address}
use cardano/assets
use cardano/transaction.{Input, NoDatum, Output, OutputReference, Transaction}
use daken/inputs_hash
use protocol

test success_only_mint_protocol_nft() {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let pid = "policy_id"
  let mint = assets.from_asset(pid, nft_name, 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test success_mint_all_nft() {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let license_name = crypto.blake2b_256(nft_name)
  let pid = "policy_id"
  let mint =
    assets.from_asset(pid, nft_name, 1) |> assets.add(pid, license_name, 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_only_mint_license_nft() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let license_name = crypto.blake2b_256(nft_name)
  let pid = "policy_id"
  let mint = assets.from_asset(pid, license_name, 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_invalid_name_protocol_nft() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let invalid_name = "invalid"
  let pid = "policy_id"
  let mint = assets.from_asset(pid, invalid_name, 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_invalid_name_license_nft() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let invalid_license_name = "invalid_license"
  let pid = "policy_id"
  let mint =
    assets.from_asset(pid, nft_name, 1)
      |> assets.add(pid, invalid_license_name, 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_invalid_quantity_protocol_nft() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let pid = "policy_id"
  let mint = assets.from_asset(pid, nft_name, 2)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_invalid_quantity_license_nft() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let license_name = crypto.blake2b_256(nft_name)
  let pid = "policy_id"
  let mint =
    assets.from_asset(pid, nft_name, 1) |> assets.add(pid, license_name, 2)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_nft_name_is_empty() fail {
  let inputs = []
  let pid = "policy_id"
  let mint = assets.from_asset(pid, #"", 1)

  protocol.one_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test success_mint_multi_shot() {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let pid = "policy_id"
  let mint = assets.from_asset(pid, nft_name, 1000)

  protocol.multi_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_multi_shot_invalid_name() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let invalid_name = "invalid"
  let pid = "policy_id"
  let mint = assets.from_asset(pid, invalid_name, 1000)

  protocol.multi_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_multi_shot_invalid_quantity() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let pid = "policy_id"
  let mint = assets.from_asset(pid, nft_name, -1)

  protocol.multi_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}

test fail_mint_multi_shot_name_mint_other_invalid_token() fail {
  let inputs =
    [
      Input {
        output_reference: OutputReference {
          transaction_id: "aa",
          output_index: 0,
        },
        output: Output {
          address: Address {
            payment_credential: address.VerificationKey(""),
            stake_credential: None,
          },
          value: assets.zero,
          datum: NoDatum,
          reference_script: None,
        },
      },
    ]
  let nft_name = inputs_hash.blake2b_256(inputs)
  let pid = "policy_id"
  let mint =
    assets.from_asset(pid, nft_name, 1000) |> assets.add(pid, "some", 1000)

  protocol.multi_shot.mint(
    None,
    pid,
    Transaction { ..transaction.placeholder, inputs: inputs, mint: mint },
  )
}
