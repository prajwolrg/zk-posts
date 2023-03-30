RECORD="{
  owner: aleo1acqtj54fj8jgdhq2sk36we3xz45wk7090pf9xhxygv73re6q75qqfndv6g.private,
  gates: 100000000u64.private,
  _nonce: 1682710088856821825961820080701665429640069534691531062671101310423063458997group.public
}"
PRIVATEKEY="APrivateKey1zkpGWbPXNScC62Ww5jHxFTWa6st1wosnuKd693QVfHKyX7K"

APPNAME="postsV"
snarkos developer deploy "${APPNAME}.aleo" \
--private-key "${PRIVATEKEY}" \
--query "https://vm.aleo.org/api" \
--path "./build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 12000000 --record "${RECORD}"