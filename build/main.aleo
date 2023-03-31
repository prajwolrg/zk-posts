program postsVII.aleo;

record post_owner:
    owner as address.private;
    gates as u64.private;
    cid as field.private;

struct Url:
    part1 as field;
    part2 as field;

struct Tips:
    total as u64;
    uncollected as u64;

record post_info:
    owner as address.private;
    gates as u64.private;
    cid as field.private;
    url as Url.private;
    tips as Tips.private;

mapping is_posted:
	key left as field.public;
	value right as u8.public;
function post:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as field.public;
    cast self.caller 0u64 r2 into r3 as post_owner.record;
    cast r0 r1 into r4 as Url;
    cast 0u64 0u64 into r5 as Tips;
    cast aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7 0u64 r2 r4 r5 into r6 as post_info.record;
    output r3 as post_owner.record;
    output r6 as post_info.record;

    finalize r2;

finalize post:
    input r0 as field.public;
    increment is_posted[r0] by 255u8;

function transfer_post:
    input r0 as post_owner.record;
    input r1 as address.private;
    cast r1 0u64 r0.cid into r2 as post_owner.record;
    output r2 as post_owner.record;

function tip:
    input r0 as post_info.record;
    cast r0.url.part1 r0.url.part2 into r1 as Url;
    add r0.tips.total 1u64 into r2;
    add r0.tips.uncollected 1u64 into r3;
    cast r2 r3 into r4 as Tips;
    cast aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7 0u64 r0.cid r1 r4 into r5 as post_info.record;
    output r5 as post_info.record;

function collect:
    input r0 as post_info.record;
    input r1 as post_owner.record;
    input r2 as u64.public;
    assert.eq r1.cid r0.cid;
    cast r0.url.part1 r0.url.part2 into r3 as Url;
    sub r0.tips.uncollected r2 into r4;
    cast r0.tips.total r4 into r5 as Tips;
    cast aleo19y76nuaemq6lgukrwmghg5pj9f3ren2yae8k5lr6vlwkdcpcrups63xnc7 0u64 r0.cid r3 r5 into r6 as post_info.record;
    output r6 as post_info.record;
