use aiken/builtin
use aiken/collection/list
use aiken/crypto
use aiken/primitive/bytearray
use cardano/address
use cardano/assets
use cardano/transaction.{Input, NoDatum, Output, OutputReference}
use daken/types.{Blake2b224Hash, Blake2b256Hash}

pub fn blake2b_256(inputs: List<Input>) -> Blake2b256Hash {
  inputs
    |> list.foldl(
        #"",
        fn(
          Input {
            output_reference: OutputReference { transaction_id, output_index },
            ..
          }: Input,
          ret: ByteArray,
        ) -> ByteArray {
          builtin.integer_to_bytearray(False, 0, output_index)
            |> bytearray.concat(transaction_id, _)
            |> bytearray.concat(ret, _)
        },
      )
    |> crypto.blake2b_256
}

test succ_blake2b_256() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   list.foldl(
  //     [utxo1, utxo2, utxo3, utxo4, utxo5],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_256([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"8a224d36fc099f567b93a46c52f56e727a0c7f6cab57254ac43266c999713996"
}

pub fn blake2b_224(inputs: List<Input>) -> Blake2b224Hash {
  inputs
    |> list.foldl(
        #"",
        fn(
          Input {
            output_reference: OutputReference { transaction_id, output_index },
            ..
          }: Input,
          ret: ByteArray,
        ) -> ByteArray {
          builtin.integer_to_bytearray(False, 0, output_index)
            |> bytearray.concat(transaction_id, _)
            |> bytearray.concat(ret, _)
        },
      )
    |> crypto.blake2b_224
}

test succ_blake2b_224() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   list.foldl(
  //     [utxo1, utxo2, utxo3, utxo4, utxo5],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_224([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"8866471e4f94c07f8a2f20f3e825c9ab4899ed1d570a4e4a8e6e7bd7"
}
