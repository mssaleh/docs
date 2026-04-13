# Docs Mirror

This repository keeps local markdown snapshots of documentation for a small set of tools that are used regularly:

- React
- Next.js
- Claude Code
- Claude API and SDK
- Model Context Protocol
- LlamaIndex

The repo is intentionally scriptless. Syncing is handled by GitHub Actions and configured through a manifest.

## How It Works

The workflow is defined in `.github/workflows/sync-docs.yml`.

It runs daily and decides what to sync based on `.github/doc-sync-sources.json` and `.github/doc-sync-state.json`.

- React, Next.js, Claude Code, Model Context Protocol, and LlamaIndex are checked against the latest GitHub release from their upstream repositories.
- Claude API and SDK do not expose a version stream that is useful for this purpose, so they are synced on a 7 day interval.
- Each sync downloads `llms.txt`, extracts markdown URLs, mirrors the markdown files into the matching local directory, and updates version files where applicable.
- Stale markdown files are pruned if they no longer exist upstream.
- The workflow commits changes back to the repository automatically.

## Source Configuration

Source definitions live in `.github/doc-sync-sources.json`.

Each source can define:

- The local target directory
- The upstream `llms.txt` URL
- The URL prefix to strip when mapping remote files to local paths
- How update detection works
- Optional version file output
- Optional URL rewrites for malformed `llms.txt` entries
- Optional extra managed files, such as `CHANGELOG.md`

## State Tracking

`.github/doc-sync-state.json` stores the last known synced version and timestamp for each source.

This file is the workflow's memory. It is used to decide whether a source should be synced during the next scheduled run.

## Manual Runs

The workflow supports manual dispatch from GitHub Actions.

Available inputs:

- `force`: sync even if no new release or interval trigger is detected
- `source`: limit the run to one source id: `react`, `nextjs`, `claude-code`, `claude-api`, `mcp`, or `llamaindex`

## Repository Layout

- `react/`: React docs mirror
- `nextjs/`: Next.js docs mirror
- `code/`: Claude Code docs mirror
- `claude/`: Claude API and SDK docs mirror
- `mcp/`: Model Context Protocol docs mirror
- `llamaindex/`: LlamaIndex docs mirror
- `.github/doc-sync-sources.json`: source manifest
- `.github/doc-sync-state.json`: sync state
- `.github/workflows/sync-docs.yml`: automation workflow

## Notes

- This setup uses scheduled polling because GitHub Actions cannot directly subscribe to release events from external repositories.
- Dependabot is not used because this repository is not managing package dependencies. It is mirroring documentation snapshots and release metadata.
