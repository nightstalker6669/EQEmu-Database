# RoF2 Offline Bazaar Trader

- Add the native RoF2 Offline Mode action for Bazaar traders, gated by `Bazaar:EnableOfflineTraders` and disabled by default.
- Keep the seller and listings active when the client returns to Character Select. An authenticated Enter World request retires the offline seller and waits for its final save and inventory release before admission.
- Use in-person checkout for RoF2 Trader sessions opened while the rule is enabled. Reserve each listing for one buyer during checkout and reject parcel requests for those listings before charging the buyer.
