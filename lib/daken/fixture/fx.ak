use cardano/address
use daken/fixture/output_builder

pub fn nft_input(
  verification_key: ByteArray,
  nft_pid: ByteArray,
  nft_name: ByteArray,
) {
  output_builder.new(address.from_verification_key(verification_key))
    |> output_builder.add_asset(nft_pid, nft_name, 1)
    |> output_builder.to_input
}
