PRIVATEKEY="APrivateKey1zkpGWbPXNScC62Ww5jHxFTWa6st1wosnuKd693QVfHKyX7K"
snarkos developer execute \
"postsVI.aleo" "post" "1field" "1field" "1field" \
--private-key "${PRIVATEKEY}" \
--query "https://vm.aleo.org/api" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast"
# --display 