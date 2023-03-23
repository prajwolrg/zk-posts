import wcredits.leo;

// The 'posts' program.

// Posts allows for zk-enabled knowledge sharing.
// Each bit of knowledge shared is termed as 'post'
// Users will be able post anonymously,
// Tip the posts anonymously if they like the content,
// The original creator of the post will be able to collect those posts

program posts.aleo {

	// The post_owner record is used to track the ownership of the post
    // Anyone who holds the post_owner record for a particular cid will be 
    // able to collect the tips that's received by the post.
    // cid [Content Identifier] is used to uniquely identify the post
    record post_owner {
        owner: address,
        gates: u64,
        cid: field
    }

    // This mapping is used to publicly track the uncollected tips
    // Usage: uncollected_tips[cid] = tip_amount
    mapping uncollected_tips: field => u64;

    // This mapping is used to publicly track the total tips
    // Usage: total_tips[cid] = tip_amount
    mapping total_tips: field => u64;

    // This mapping is used to publicly track the total royalty
    // Usage: total_royalty[cid] = royalty_amount
    mapping total_royalty: field => u64;

    // This mapping is used to publicly track the uncollected royalty
    // Usage: uncollected_royalty[cid] = royalty_amount
    mapping uncollected_royalty: field => u64;

    // This transition is used to broadcast a particular post
    // post_owner record is created for tracking the owner of the particular post
    transition post(public cid: field) -> post_owner{
        return post_owner {
            owner: self.caller,
            gates: 0u64,
            cid: cid
        };
    }

    transition mint_token(receiver: address, amount: u64) -> wcredits.leo/credits.record {
        return wcredits.leo/mint(receiver, amount);
    }


    // This transition is used to transfer ownership of post to a new address
    // post_owner record is created for tracking the owner of the particular post
    transition transfer_post(sender: post_owner, recipient: address) -> post_owner{
        return post_owner {
            owner: recipient,
            gates: 0u64,
            cid: sender.cid
        };
    }

    // This transition is used to tip a particular post
    // cid is a public parameter for tracking the tips in a mapping
    transition tip(public cid: field, tip_record: wcredits.leo/credits.record) {
        return then finalize(cid, tip_record.gates);
    }

    // total_tips[cid] += amount
    finalize tip(cid: field, amount: u64) {
        increment(total_tips, cid, amount);
    }

    // This transition is used to collect the tips that has been collected by a particular post
    // post_owner record must be provided to ensure that only the post owner can collect the tips
    transition collect(public cid: field, collector: post_owner, public amount: u64) -> (wcredits.leo/credits.record, post_owner) {
        assert_eq(collector.cid, cid);
        let newcredits: credits = wcredits.leo/mint(collector.owner, amount);
        return (newcredits, collector) then finalize(cid, amount);
    }

    // uncollected_tips[cid] -= amount
    finalize collect(cid: field, amount: u64) {
        decrement(uncollected_tips, cid, amount);
    }

}
