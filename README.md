# EQEmu Database provenance and migrations

This downstream package documents the database actually used to bootstrap this server: **PEQ dump 2025-09-28, schema9328**, imported on **2026-10-12** with EQEmu **v23.10.3**. It is not a fork of an upstream database source repository.

The original [GitLab package file 232952944](https://gitlab.com/TheGrandLibrary/db.projecteq.net-dumps/-/package_files/232952944/download) is a 32,150,987-byte ZIP with SHA256:

```text
ac8649f23d2c3aea2cade138dfe10d46d1b21ad1a80d08ca95f5434fab7f218d
```

`baseline-manifest.json` records the exact member hashes, import order and matched original server source commit. Local archive and extracted-member bytes were reverified. No independent upstream checksum was recorded. Dump timestamps have no established timezone. The [upstream GitLab project](https://gitlab.com/TheGrandLibrary/db.projecteq.net-dumps) reports an empty repository; its package distribution does not establish a Git commit to fork on GitHub.

## Reproduction references

Obtain the exact original ZIP from its source and verify its size and SHA256 before extraction. Verify extracted member hashes against the manifest. The original bootstrap imported content, login, player, state and system SQL, in that order, into a fresh database named `peq`. The archive's `create_all_tables.sql` supplies the same order using relative `source` commands. Those files contain destructive DROP/CREATE statements; this reference describes original fresh bootstrap and is not an upgrade command for an existing server.

The original post-import EQEmu updater reported database9328/binary9328 already up to date. The exact initial clone/import from `peq` into the housing database remains unlocated. Retained setup documentation records consolidation onto the existing housing instance on 2026-10-15 without replacing/copying that data. The current modified database is not a pristine baseline.

## Existing deltas and release assembly

`source-delta-inventory.json` hashes available housing and dated custom SQL in the inspected server source. It includes state/schema prerequisites and optional work; it is neither an executable order nor a public content allowlist. File presence does not establish installation, and current file hashes can differ from their source HEAD. `reported-delta-status.json` preserves selected applied/proposed status and qualifications reported by the coordinator; exact application receipts still need matching. Both inventories are preliminary and non-exhaustive.

Future ordered migrations must preserve feature dependency order, original preimages, exact code compatibility, application status, disabled/proposed work, historical evidence and explicitly selected emulator defaults. A publication commit or schema version alone does not establish installed content or native acceptance.

This first package contains documentation and hash inventories only. No archive redistribution or full SQL snapshot is included. Later downloadable snapshots will contain intended server content and version manifests, excluding accounts, characters, inventory, custody, credentials, logs, private paths and temporary QA artifacts. Baseline redistribution terms remain to be established before packaging the upstream dump. The dump's distribution date does not establish May 2013 historical accuracy.
