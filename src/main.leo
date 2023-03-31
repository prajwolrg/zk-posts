// The 'posts' program.

// Posts allows for zk-enabled knowledge sharing.
// Each bit of knowledge shared is termed as 'post'
// Users will be able post anonymously,
// Tip the posts anonymously if they like the content,
// The original creator of the post will be able to collect those posts

program postsVII.aleo {

	// The post_owner record is used to track the ownership of the post
    // Anyone who holds the post_owner record for a particular cid will be 
    // able to collect the tips that's received by the post.
    // cid [Content Identifier] is used to uniquely identify the post
    record post_owner {
        owner: address,
        gates: u64,
        cid: field // Single value to id the post (some arbitrary computation from cid1, cid2)
    }

    struct Url {
        part1: field,
        part2: field
    }

    struct Tips {
        total: u64,
        uncollected: u64
    }

	// The post is owned by a particular address that is public
    // This can be used to query all the records that has been owned by that particular address
    record post_info {
        owner: address,
        gates: u64,
        cid: field,
        url: Url,
        tips: Tips
    }

    // This mapping is used to publicly prevent multiple owner of the same post
    // Usage: is_posted[cid] = 255 / 0 
    mapping is_posted: field => u8;

    // This transition is used to broadcast a particular post
    // post_owner record is created for tracking the owner of the particular post
    // transition post(public cid1: field, public cid2: field, public cid: field) -> (post_owner, post_info) {
    transition post(public url1: field, public url2: field, public cid: field) -> (post_owner, post_info) {
        let collector: post_owner = post_owner {
            owner: self.caller,
            gates: 0u64,
            cid: cid
        };

        let post_details: post_info = post_info {
            owner: aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7,
            gates: 0u64,
            cid: cid,
            url: Url {
                part1: url1,
                part2: url2
            },
            tips: Tips {
                total: 0u64,
                uncollected: 0u64
            }
        };

        // return (collector, post_information) then finalize(cid);
        return (collector, post_details) then finalize(cid);
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
    transition tip(post_details: post_info) -> post_info {
        let updated_post_details: post_info = post_info {
            owner: aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7,
            gates: 0u64,
            cid: post_details.cid,
            url: Url {
                part1: post_details.url.part1,
                part2: post_details.url.part2
            },
            tips: Tips {
                total: post_details.tips.total + 1u64,
                uncollected: post_details.tips.uncollected + 1u64
            }
        };

        return updated_post_details;
    }

    // This transition is used to collect the tips that has been collected by a particular post
    // post_owner record must be provided to ensure that only the post owner can collect the tips
    transition collect(post_details: post_info, collector: post_owner, public amount: u64) -> post_info {
        assert_eq(collector.cid, post_details.cid);
        let updated_post_details: post_info = post_info {
            owner: aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7,
            gates: 0u64,
            cid: post_details.cid,
            url: Url {
                part1: post_details.url.part1,
                part2: post_details.url.part2
            },
            tips: Tips {
                total: post_details.tips.total,
                uncollected: post_details.tips.uncollected - amount
            }
        };
        return updated_post_details;
    }

    // uncollected_tips[cid] -= amount
    // finalize collect(cid: field, amount: u64) {
    //     decrement(uncollected_tips, cid, amount);
    // }

}