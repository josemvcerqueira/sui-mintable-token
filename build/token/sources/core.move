module token::core {
  use std::option;

  use sui::tx_context::{Self, TxContext};
  use sui::transfer;
  use sui::coin::{Self, Coin, TreasuryCap};

  const AMOUNT: u64 = 600000000000000000; // 600M 60% of the supply

  struct CORE has drop {}

  fun init(witness: CORE, ctx: &mut TxContext) {
      // Create the IPX governance token with 9 decimals
      let (treasury, metadata) = coin::create_currency<CORE>(
            witness, 
            9,
            b"TOKEN",
            b"Random Token",
            b"Random Token",
            option::none(),
            ctx
        );

      let sender = tx_context::sender(ctx);  

      coin::mint_and_transfer(&mut treasury, AMOUNT, sender, ctx);

      transfer::public_transfer(treasury, sender);

      // Freeze the metadata object
      transfer::public_freeze_object(metadata);
  }

  entry fun mint(
        cap: &mut TreasuryCap<CORE>, value: u64, sender: address, ctx: &mut TxContext,
    ) {
     coin::mint_and_transfer(cap, value, sender, ctx);
  }

  /**
  * @dev A utility function to transfer IPX to a {recipient}
  * @param c The Coin<IPX> to transfer
  * @param recipient The recipient of the Coin<IPX>
  */
  public entry fun transfer(c: Coin<CORE>, recipient: address) {
    transfer::public_transfer(c, recipient);
  }
}