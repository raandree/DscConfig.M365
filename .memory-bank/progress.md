---
status: current
last-verified: 2026-08-30
owner: active-agent
source: repository evidence
---

# Progress

## Current status

`main` is at `c1f5098`. Azure DevOps build `1288` failed only in the
`Windows (Windows PowerShell)` test job; the fix is committed on a topic branch
and not yet pushed.

## Recent milestones

- 2026-08-30 Diagnosed build `1288`: `da590d5` added `- build` to the `test`
  workflow, so the 5.1 test job died on `TestPowerShell7`. Removed it from
  `build.yaml`.
- 2026-08-07 Documentation refreshed: added `docs/GettingStarted.md`, corrected
  the Microsoft365DscWorkshop repository URL and integration model, fixed invalid
  resource properties in the examples, and replaced the stale hard-coded list in
  `docs/Resources.md`.
- 2026-08-04 Microsoft365DSC bumped to `1.26.729.2`; composite generator fixed
  for embedded CIM instance types and 21 test config assets realigned with the
  new schemas. `./build.ps1 -Tasks build,test` is green (509 passed, 0 failed).
- 2026-08-04 Memory Bank initialized from repository evidence.
- `333142b` Update Microsoft365DSC version to 1.25.521.1 (#44).
- `46c86a1` Updated documentation (#42), released as `v0.6.0`.
- `b37ca52` Feature/common parameters (#41) — shared authentication parameters
  on `Array` composite resources.
- `49a4806` Security and Compliance composite resources (#38), `v0.5.0`.

## Stable capabilities

- Build-time generation of `Scalar` and `Array` composite resources for the
  Microsoft365DSC resources selected by the test config assets (176 assets).
- Pester compile tests that emit one MOF per resource into `output/MOF` and
  assert Azure connection data is present.
- Sampler packaging, GitVersion versioning, and the Azure Pipelines
  build/test/deploy stages.

## Open work

- Push the `ai/fix-test-workflow-ps7-guard` branch and confirm the
  `Windows (Windows PowerShell)` job goes green.
- Decide whether `DscBuildHelpers` and `PSDesiredStateConfiguration` stay on
  `latest` (currently unpinned, previously pinned to `0.3.0-preview0003` and
  `2.0.7`).
- The remaining `MD013` line-length warnings in `README.md`, `docs/Usage.md`,
  `docs/Examples.md`, `docs/Integration.md` and `CHANGELOG.md` are pre-existing
  prose that was not rewritten.
