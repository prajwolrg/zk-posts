PRIVATEKEY="APrivateKey1zkpGWbPXNScC62Ww5jHxFTWa6st1wosnuKd693QVfHKyX7K"
snarkos developer execute \
"posts.aleo" "post" "2793123896416649578508430956173875066425468388805468715479907750778834469731416946970field" \
--private-key "${PRIVATEKEY}" \
--query "https://vm.aleo.org/api" \
# --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast"
-- display