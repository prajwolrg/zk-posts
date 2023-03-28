// The 'posts' program.

// Posts allows for zk-enabled knowledge sharing.
// Each bit of knowledge shared is termed as 'post'
// Users will be able post anonymously,
// Tip the posts anonymously if they like the content,
// The original creator of the post will be able to collect those posts

program postsV.aleo {

    record credits {
        owner: address,
        gates: u64,
        amount: u64
    }

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

    // This mapping is used to publicly prevent multiple owner of the same post
    // Usage: is_posted[cid] = 255 / 0 
    mapping is_posted: field => u8;

    transition mint(receiver: address, amount: u64) -> credits {
        return credits {
            owner: receiver,
            gates: 0u64,
            amount: amount
        };
    }

    // transition transfer(sender: credits, receiver: address, amount: u64) -> (credits, credits) {
    //     let difference: u64 = sender.amount - amount;

    //     let transferred: credits = credits {
    //         owner: receiver,
    //         gates: 0u64,
    //         amount: amount
    //     };

    //     let remaining: credits = credits {
    //         owner: sender.owner,
    //         gates: 0u64,
    //         amount: difference
    //     };

    //     return (transferred, remaining);
    // }

    // transition join(first: credits, second: credits) -> credits {

    //     return credits {
    //         owner: first.owner,
    //         gates: 0u64,
    //         amount: first.amount + second.amount
    //     };

    // }

    // transition split(sender: credits, amount: u64) -> (credits, credits) {
    //     let difference: u64 = sender.gates - amount;

    //     let transferred: credits = credits {
    //         owner: sender.owner,
    //         gates: 0u64,
    //         amount: amount
    //     };

    //     let remaining: credits = credits {
    //         owner: sender.owner,
    //         gates: 0u64,
    //         amount: amount
    //     };

    //     return (transferred, remaining);
    // }

    // transition fee(sender: credits, amount: u64) -> credits {
    //     let difference: u64 = sender.gates - amount;

    //     let remaining: credits = credits {
    //         owner: sender.owner,
    //         gates: 0u64,
    //         amount: amount
    //     };

    //     return remaining;
    // }

    // This transition is used to broadcast a particular post
    // post_owner record is created for tracking the owner of the particular post
    transition post(public cid: field) -> post_owner{
        let collector: post_owner = post_owner {
            owner: self.caller,
            gates: 0u64,
            cid: cid
        };
        return collector then finalize(cid);
    }

    finalize post(cid: field) {
        increment(is_posted, cid, 255u8);
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
    transition tip(public cid: field, tip_record: credits) {
        return then finalize(cid, tip_record.gates);
    }

    // total_tips[cid] += amount
    finalize tip(cid: field, amount: u64) {
        increment(total_tips, cid, amount);
    }

    // This transition is used to collect the tips that has been collected by a particular post
    // post_owner record must be provided to ensure that only the post owner can collect the tips
    transition collect(public cid: field, collector: post_owner, public amount: u64) -> (credits, post_owner) {
        assert_eq(collector.cid, cid);
        let newcredits: credits = credits {
            owner: collector.owner,
            gates: 0u64,
            amount: amount
        };
        let newCollector: post_owner = post_owner {
            owner: collector.owner,
            gates: 0u64,
            cid: cid
        };
        return (newcredits, newCollector) then finalize(cid, amount);
    }

    // uncollected_tips[cid] -= amount
    finalize collect(cid: field, amount: u64) {
        decrement(uncollected_tips, cid, amount);
    }

}
