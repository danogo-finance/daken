use aiken/builtin
use aiken/collection/list
use aiken/crypto
use aiken/primitive/bytearray
use cardano/transaction.{OutputReference}
use daken/types.{Blake2b224Hash, Blake2b256Hash}

pub fn blake2b_256(out_refs: List<OutputReference>) -> Blake2b256Hash {
  out_refs
    |> list.foldl(
        #"",
        fn(
          OutputReference { transaction_id, output_index }: OutputReference,
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
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"8a224d36fc099f567b93a46c52f56e727a0c7f6cab57254ac43266c999713996"
}

test succ_blake2b_256_empty() {
  crypto.blake2b_256(#"") == #"0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8"
}

pub fn blake2b_224(out_refs: List<OutputReference>) -> Blake2b224Hash {
  out_refs
    |> list.foldl(
        #"",
        fn(
          OutputReference { transaction_id, output_index }: OutputReference,
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
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"8866471e4f94c07f8a2f20f3e825c9ab4899ed1d570a4e4a8e6e7bd7"
}

test succ_blake2b_224_empty() {
  crypto.blake2b_224(#"") == #"836cc68931c2e4e3e838602eca1902591d216837bafddfe6f0c8cb07"
}
