program postsV.aleo;

record credits:
    owner as address.private;
    gates as u64.private;
    amount as u64.private;

record post_owner:
    owner as address.private;
    gates as u64.private;
    cid as field.private;

mapping uncollected_tips:
	key left as field.public;
	value right as u64.public;

mapping total_tips:
	key left as field.public;
	value right as u64.public;

mapping total_royalty:
	key left as field.public;
	value right as u64.public;

mapping uncollected_royalty:
	key left as field.public;
	value right as u64.public;

mapping is_posted:
	key left as field.public;
	value right as u8.public;
function mint:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 0u64 r1 into r2 as credits.record;
    output r2 as credits.record;

function post:
    input r0 as field.public;
    cast self.caller 0u64 r0 into r1 as post_owner.record;
    output r1 as post_owner.record;

    finalize r0;

finalize post:
    input r0 as field.public;
    increment is_posted[r0] by 255u8;

function transfer_post:
    input r0 as post_owner.record;
    input r1 as address.private;
    cast r1 0u64 r0.cid into r2 as post_owner.record;
    output r2 as post_owner.record;

function tip:
    input r0 as field.public;
    input r1 as credits.record;

    finalize r0 r1.gates;

finalize tip:
    input r0 as field.public;
    input r1 as u64.public;
    increment total_tips[r0] by r1;

function collect:
    input r0 as field.public;
    input r1 as post_owner.record;
    input r2 as u64.public;
    assert.eq r1.cid r0;
    cast r1.owner 0u64 r2 into r3 as credits.record;
    cast r1.owner 0u64 r0 into r4 as post_owner.record;
    output r3 as credits.record;
    output r4 as post_owner.record;

    finalize r0 r2;

finalize collect:
    input r0 as field.public;
    input r1 as u64.public;
    decrement uncollected_tips[r0] by r1;
