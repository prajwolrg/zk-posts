// The 'credits' program.

// This program is generated based on credits.aleo in:
//https://aleo.tools/ REST API tab / Get Program credits.aleo
program wcredits.aleo {

    record credits {
        owner: address,
        gates: u64
    }

    transition mint(receiver: address, amount: u64) -> credits {
        return credits {
            owner: receiver,
            gates: amount
        };
    }

    transition transfer(sender: credits, receiver: address, amount: u64) -> (credits, credits) {
        let difference: u64 = sender.gates - amount;

        let transferred: credits = credits {
            owner: receiver,
            gates: amount
        };

        let remaining: credits = credits {
            owner: sender.owner,
            gates: difference
        };

        return (transferred, remaining);
    }

    transition join(first: credits, second: credits) -> credits {

        return credits {
            owner: first.owner,
            gates: first.gates + second.gates
        };

    }

    transition split(sender: credits, amount: u64) -> (credits, credits) {
        let difference: u64 = sender.gates - amount;

        let transferred: credits = credits {
            owner: sender.owner,
            gates: amount
        };

        let remaining: credits = credits {
            owner: sender.owner,
            gates: difference
        };

        return (transferred, remaining);
    }

    transition fee(sender: credits, amount: u64) -> credits {
        let difference: u64 = sender.gates - amount;

        let remaining: credits = credits {
            owner: sender.owner,
            gates: difference
        };

        return remaining;
    }
}