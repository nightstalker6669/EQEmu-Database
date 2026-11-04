# Matima: Flashflares and Scalding Blast rank I

SOURCE ONLY, never applied or registered. Two proposed merchantlist inserts on existing Matima724039: slot103/item131772→29772/WIZ94 and slot104/item131958→29958/MAG94. Native rankIidentities and positive base prices1223131/1223925copper are preserved. The native list has71rows with lastslot102, not102rows; adding2gives73rows while preserving every existing slot/hole and mixed25/50Alaran requirement. No NPC, spell/classlevel, item, original stock or player state is changed by source preparation. Publication through JARVIS/GitHub precedes coordinated apply.

## Historical membership and selected local threshold

Original November18,2011merchant log at AllakhazamNPC38162commentmsg1321672908254769711 explicitly lists released Flashflares and ScaldingBlast. Current public spell29772SoldBy and Matima's current named inventory corroborate both exact scrolls. This is dated original vendor membership, not a class-level-only guess.

**Alaran proficiency50is an explicitly selected configurable local default. The exact original per-scroll threshold is unverified.** Rasper's VoAlevel94/Matima tables list50for the apparent lines, but use different names Flashfires/ScaldingBurst. Native Flashfires10841is WIZ74; it must not replace targetFlashflares29772. No exact alias/rename proof was recovered. General guides agree common94–95requires25and uncommon94–95requires50, but that alone does not prove classification of these exact scrolls. The language50selection follows coordinator application of the user's standing configurable-default policy, with the uncertainty preserved. It must never be described as recovered original numeric entitlement.

Use existing native Alaran language enforcement: database language_required25/skill50 on both new rows, min_expansion18, standing-1100, standard platinum policy/no alternate currency. These fields follow current merchant conventions; no new Lua purchase gate, replacement scroll, manual summon or rankII/IIIsubstitution is introduced. Existing71rows and their original25/50/ungated values remain unchanged. No rankII/IIIgate is inferred or edited.

## Guarded application and recovery

`python3 apply_database.py` is a database-free plan. Later --apply requires private --config and a fresh --receipt-dir. It checks exact full71stock, full actor, sole consumers and two complete native item/spell preimages, expected mappings/levels/ranks/prices, transactional engine and absent slots/items. Full-row snapshots retain their known JSONdefault=str timestamp representation. Prepared backup is durable and exclusive; only these two rows are inserted in one transaction; full73postimage is checked before commit.

--readback with private config/fresh receipt directory independently checks full73stock plus unchanged actor/consumer/item/spell rows. Prepared-only or uncertain completion state must be reconciled against exact postimages; never retry blindly. A later rollback may remove only the exact matching two owned rows after verifying original stock/definitions/sole-consumers and no new dependent state; it must never rewrite old stock, items, language skill or player purchases. No automatic broad rollback is emitted.

JARVIS/Build owns any later Argath724 merchant freshness. No items/spells/tasks changed, so another definition catalog rebuild is not implied. No own runtime/cache/client action, purchase/learning test or native acceptance claim. The helper is supplied for review/publication, not invoked by source preparation.
