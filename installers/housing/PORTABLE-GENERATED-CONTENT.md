# Portable housing generated-content contract

Scope: source-only contract supplementing Database's `HOUSING-GENERATED-OUTPUT-PLAN-20261104.md` and its 12 existing source bindings. No database query, executable, generator, resource copy, test or runtime operation was performed.

## Supported fresh-target release

Package the current integrated source's `extensions/rof2/housing/` installer, ordered migration manifest, tools, quest overlay and protocol metadata together with the integrated `common/shared_core`, housing/world/zone implementations and normal build dependencies. Follow `docs/rof2/INSTALL.md` with `tools/install_housing.py --integrated-source`. Keep this documented workflow as the runnable reconstruction path; an SQL snapshot alone is incomplete. The already released static SQL set needs no new production-row export.

Inputs are a target server/configuration and compatible PEQ schema, the matching integrated build, an operator-chosen installation key/name, source `house_variant_geometry.json`, `house_variant_capacities.json`, `house_variant_capacity_defaults.json`, compiled house/furniture/mesh registries, and private matching original client resources/collision maps. Preserve the JSON's researched versus configurable-default provenance.

The installer imports original geometry sidecars, generates variant house/room manifests and registries plus `housing-catalogue-proposal.json`, registers capacity templates, and calls `housing_install --apply ... --reconstructed-defaults`. It also installs quests/mapping, generates shared memory and enables its documented rules. Use its existing complete operation rather than inventing a second static seed pipeline.

## Identity allocation and embedded fields

`content_install.cpp:38–44` uses `PersistenceService::CreateNeighborhood("install:"+key, name, 712, 0)` to allocate the target neighborhood/instance and `DefinePlot` for 71 personal and four guild plots. `SunriseNeighborhoodDefaults::Build` receives those target plot/neighborhood IDs; its nodes initially have no native estate IDs. `Catalog::Service::Import` allocates native estate IDs and resolves parent-node links. Purchase/upkeep policies use the resulting catalogue key/revision and exact payload hashes. `housing_content_installations` is a local completion receipt; an identical key/source/name returns the existing installation instead of making another neighborhood.

Correction to earlier broad wording: the inspected definition/region bootstrap blobs contain catalogue definition/region/price IDs, NOT allocated native estate IDs. Runtime native/neighborhood/plot/ownership identities are in the accompanying node graph. Current code selects definition root 1200000, plot definitions 1200001 onward, region IDs 1300001 onward and prices 1400001 onward within the catalogue namespace. Do not substitute live estate IDs into these fields or globally renumber a SQL dump. Reconstruct the bundle and graph together through the services.

## Capacity templates versus existing owned houses

For a NEW target with no owned house/interior records, the existing capacity tool's `Rooms` result is empty: it registers generated template grants and has no owned-room upgrades to apply. This already supports the fresh-target release; no new template-only mode or projection is required for that route.

For an EXISTING server, `housing_capacity` is a player-preserving policy upgrade, NOT a portable content exporter: `--plan` connects and locks rooms, `--dry-run` executes registration/upgrade writes then rolls back, and `--apply` commits. It compares immutable base manifests/profile hashes, preserves ownership/custody, and writes per-house policy/head history. Do not include those histories in a public seed or describe these modes as pure offline commands.

The narrow pure projection is already the SOURCE JSON policy plus generated house/room manifests: item template, definition/type, effective limits and child definitions, policy revision, base resource/profile identities and provenance. Keep it in that file format for target registration. If Database later requires a separate template-only registration command for mixed existing targets, its implementation would reuse `Project` + `RegisterTemplateUnderTransaction`, omit `Rooms` + `UpgradeUnderTransaction`, and preserve the existing exact-base/hash contract. That is an optional future convenience, not a blocker to this fresh-target release.

## Operator resources and remaining gap

The portable package cannot supply third-party client archives/meshes. Operators supply the supported RoF2 `eqgame.exe`, `eqgraphicsdx9.dll`, `Resources/OnDemandResources.txt`, `Resources/actortaginfo.txt`, required original archives/ZON members from compiled registries, and authenticated collision maps. The generator requires these twelve interior archive/map pairs: phinterior3a1, phinterior1a1, phinterior3a2, phinterior3a3, phinterior1a2, phinterior1a3, guildhall, guildhall3, guildhalllrg, guildhallsml, phinteriortree and phinterior1d1. The content installer additionally requires reviewed `neighborhood.map` and `furniture06.eqg`/moving-crate metadata. Exact expected hashes are in the retained source registries/geometry JSON. The original-mesh importer does not generate missing collision maps.

Concrete release gap: bundle/document the existing integrated installer and source/policy inputs, with an operator-supplied resource/map manifest; do not replace missing resources with a production row export. Availability/distribution rights for a target's matching maps/assets are not established by this source-only handoff. No current-host resource existence claim is made. Catalogues, allocated IDs, receipts, owned room policies, custody/player data and installer-proof QA rows stay local.
