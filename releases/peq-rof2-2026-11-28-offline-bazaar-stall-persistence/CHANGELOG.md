## Offline Bazaar stall recovery

- Restores eligible RoF2 Offline Mode stalls, their remaining stock and their saved locations when the Bazaar loads after a server restart. A restored stall supports native browsing, counter purchases and cross-zone parcel purchases while the seller remains logged out.
- Settles a recovered counter purchase in one transaction with the buyer's item and debit, seller proceeds, remaining stock and an idempotent receipt. Counter and parcel purchases compete for the same listing stock.
- Binds a stall to the saved Trader Satchel and the exact Bazaar instance. Sold, withdrawn and unverified stock cannot be recreated from inventory. Ordinary Enter World reclaims the remaining seller stock and proceeds.
