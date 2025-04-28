use aiken/collection/dict
use aiken/crypto
use cardano/assets.{AssetName, PolicyId}
use cardano/script_context.{ScriptContext}
use cardano/transaction.{Transaction}
use daken/inputs_hash
use daken/util

validator one_shot {
  mint(
    _rdmr: Data,
    pid: PolicyId,
    Transaction { inputs, mint, .. }: Transaction,
  ) {
    // - Mint:
    //    - NFT protocol (require):
    //      - nft_name: must be blake2b_256 hash all inputs
    //      - quantity: should be 1
    //    - NFT license (optional):
    //      - nft_license_name: must be hash blake2b_256 nft_name
    //      - quantity: should be 1
    let nft_name = inputs_hash.blake2b_256(inputs)
    let license_name = crypto.blake2b_256(nft_name)
    dict.foldl(
      assets.tokens(mint, pid),
      False,
      fn(name, qty, seen_protocol_nft) {
        if name == nft_name {
          (qty == 1)?
        } else if name == license_name {
          and {
            qty == 1,
            seen_protocol_nft,
          }?
        } else {
          fail @"minting is invalid"
        }
      },
    )
  }

  else(_) {
    fail @"support minting only"
  }
}

validator multi_shot {
  mint(
    _rdmr: Data,
    pid: PolicyId,
    Transaction { inputs, mint, .. }: Transaction,
  ) {
    let nft_name = inputs_hash.blake2b_256(inputs)
    //
    expect [Pair(asset_name, quantity)] =
      mint |> assets.tokens(pid) |> dict.to_pairs()
    //
    and {
      (asset_name == nft_name)?,
      (quantity > 0)?,
    }
  }

  else(_) {
    fail @"support minting only"
  }
}

validator nft_license(pid: PolicyId, tn: AssetName) {
  else(
    ScriptContext {
      transaction: Transaction {
        inputs,
        reference_inputs,
        extra_signatories,
        ..
      },
      ..
    }: ScriptContext,
  ) {
    // Required nft_license in inputs or reference_inputs of transaction
    // Required signatory from the owner of nft_license
    util.has_valid_nft_license(
      inputs,
      reference_inputs,
      extra_signatories,
      pid,
      tn,
    )
  }
}
