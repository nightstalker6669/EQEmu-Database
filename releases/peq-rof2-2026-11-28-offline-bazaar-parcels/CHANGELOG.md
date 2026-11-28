<!-- previous-release: rof2-ci-r42-a1-0f4fa26d4df6 -->

## Offline Bazaar parcel checkout

- Adds native cross-zone Bazaar parcel purchases from offline RoF2 traders when offline trading, Bazaar parcel delivery and parcel merchants are enabled.
- Settles the buyer debit, seller proceeds, listing and inventory changes, and parcel in one durable transaction. A retry of the same completed quote returns its original outcome.
- Keeps in-person counter sales available and synchronizes the displayed buyer balance after the native parcel purchase reply.
