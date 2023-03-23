RECORD="{
  owner: aleo1acqtj54fj8jgdhq2sk36we3xz45wk7090pf9xhxygv73re6q75qqfndv6g.private,
  gates: 100000000000u64.private,
  _nonce: 6730879446079247967546262329464096561286516411397663458500425441966137353663group.public
}"
PRIVATEKEY="APrivateKey1zkpGWbPXNScC62Ww5jHxFTWa6st1wosnuKd693QVfHKyX7K"

APPNAME="posts"
snarkos developer deploy "${APPNAME}.aleo" \
--private-key "${PRIVATEKEY}" \
--query "https://vm.aleo.org/api" \
--path "./build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 12000000 --record "${RECORD}"