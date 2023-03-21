// The 'posts' program.
program posts.aleo {

    record wcredits {
        owner: address,
        gates: u64,
        amount: u64
    }

    record post_owner {
        owner: address,
        gates: u64,
        cid: field
    }

    mapping uncollected_tips: field => u64;
    mapping total_tips: field => u64;

    transition post(public cid: field) -> post_owner{
        return post_owner {
            owner: self.caller,
            gates: 0u64,
            cid: cid
        };
    }

    transition tip(public cid: field, tip_record: wcredits) {
        return then finalize(cid, tip_record.amount);
    }

    finalize tip(cid: field, amount: u64) {
        increment(total_tips, cid, amount);
    }

    transition collect(public cid: field, collector: post_owner, public amount: u64) -> (wcredits, post_owner) {
        assert_eq(collector.cid, cid);
        let newcredits: wcredits = wcredits {
            owner: collector.owner,
            gates: 0u64,
            amount: amount
        };
        return (newcredits, collector) then finalize(cid, amount);
    }

    finalize collect(cid: field, amount: u64) {
        decrement(uncollected_tips, cid, amount);
    }

}
