RECORD="{
  owner: aleo1qzjpvd78mqlv08ng0vud8tgdr7wafx3yafndh4035v59v32a7sqsyz6ft8.private,
  gates: 100000000u64.private,
  _nonce: 3553559731143448056654052453071842618117644110493667004230285807150131995384group.public
}"
PRIVATEKEY="APrivateKey1zkp7trPMjRMToGeHpJt4TvhaQPjLARGn3HyL5GYWx6VqBXu"

APPNAME="postsVI"
snarkos developer deploy "${APPNAME}.aleo" \
--private-key "${PRIVATEKEY}" \
--query "https://vm.aleo.org/api" \
--path "./build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 12000000 --record "${RECORD}"