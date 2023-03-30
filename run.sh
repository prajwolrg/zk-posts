#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# The private key and address of the first bidder.
# Swap these into program.json, when running transactions as the first bidder.
# "private_key": "APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK"
# "address": aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke

# The private key and address of the second bidder.
# Swap these into program.json, when running transactions as the second bidder.
# "private_key": "APrivateKey1zkpAFshdsj2EqQzXh5zHceDapFWVCwR6wMCJFfkLYRKupug"
# "address": aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4

# The private key and address of the auctioneer.
# Swap these into program.json, when running transactions as the auctioneer.
# "private_key": "APrivateKey1zkp5wvamYgK3WCAdpBQxZqQX8XnuN2u11Y6QprZTriVwZVc",
# "address": "aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh"


echo "
###############################################################################
########                                                               ########
########            STEP 0: Initialize the keys							           ########
########                                                               ########
###############################################################################
"
# Swap in the private key and address of the first bidder to program.json.
echo "{
  \"program\": \"postsV.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK\",
      \"address\": \"aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke\"
  },
  \"license\": \"MIT\"
}" > program.json

# Post for the first time
echo "
###############################################################################
########                                                               ########
########          STEP 1:  Create a post                               ########
########                                                               ########
###############################################################################
"
# Converting IPFS CID (hex repr) in https://docs.ipfs.tech/concepts/content-addressing/#cid-conversion to decimal 

# Arweave (arweave.net) tx as FF -> scjQv99W2hhvxIydvoCejK3R_k3sV-fgEaUiYbpki8A = 402527374854052064221003265441617513852104232141623565551066572989268576096778
# Split into   cid_part1: '4025273748540520642210032654416175138521', cid_part2: '04232141623565551066572989268576096778',
# Use first 60 byes of hash of (cid_part1 + cid_part2) for cid to identify the post
leo run post 402527374854052064221003265441617513852field 104232141623565551066572989268576096778field 479869638392589277799556918555882776920873297777087131318614268953292887field;

echo "
###############################################################################
########                                                               ########
########          STEP 2:  Mint credits                               ########
########                                                               ########
###############################################################################
"
# Mint some token
leo run mint aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke 1000u64;


echo "
###############################################################################
########                                                               ########
########          STEP 3:  Tip the post                                ########
########                                                               ########
###############################################################################
"
# Tip the post
leo run tip 479869638392589277799556918555882776920873297777087131318614268953292887field "{
  owner: aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke.private,
  gates: 0u64.private,
  amount: 100u64.private,
  _nonce: 823431787811454510904938283634593098608691305151692245657827090711441043175group.public
}"

echo "
###############################################################################
########                                                               ########
########          STEP 4:  Collect the post                            ########
########                                                               ########
###############################################################################
"
# Collect the tip
leo run collect 479869638392589277799556918555882776920873297777087131318614268953292887field "{
  owner: aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke.private,
  gates: 0u64.private,
  cid_part1: 402527374854052064221003265441617513852field.private,
  cid_part2: 104232141623565551066572989268576096778field.private,
  cid: 479869638392589277799556918555882776920873297777087131318614268953292887field.private,
  _nonce: 630047429497224873849452081439877064635841841106269654897536787612427709802group.public
}" 10u64
