// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module sui_test_coin::test_token_1 {
    use sui::coin::{Self, Coin, TreasuryCap};

    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<TEST_TOKEN_1>`.
    public struct TEST_TOKEN_1 has drop {}

    /// Register the managed currency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: TEST_TOKEN_1, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (mut treasury_cap, metadata) = coin::create_currency<TEST_TOKEN_1>(witness, 6, b"TEST_TOKEN_1", b"TT", b"", option::none(), ctx);

        mint(&mut treasury_cap, 100000000000000, ctx.sender(), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new coins
    public fun mint(
        treasury_cap: &mut TreasuryCap<TEST_TOKEN_1>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn coins
    public fun burn(treasury_cap: &mut TreasuryCap<TEST_TOKEN_1>, coin: Coin<TEST_TOKEN_1>) {
        coin::burn(treasury_cap, coin);
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(TEST_TOKEN_1 {}, ctx)
    }
}
