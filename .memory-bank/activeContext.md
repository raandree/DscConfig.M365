---
status: current
last-verified: 2026-08-30
owner: active-agent
source: current task evidence
---

# Active context

## Current focus

Restore a green CI run. The `Windows (Windows PowerShell)` test job has failed
on every `main` build since `da590d5`.

## Evidence

- Azure DevOps build `1288` (`c1f5098`, `main`): only the
  `Windows (Windows PowerShell)` job failed, after 44 s. `Package Module`,
  `HQRM` and `Windows (PowerShell)` all succeeded.
- Task log `1288/logs/24`: `TESTPOWERSHELL7` →
  `ERROR: The build script requires PowerShell 7+ to work.` →
  `PowerShell exited with code '1'.` The follow-up
  `Publish Test MOF5 Files` task then reported
  `Path does not exist: D:\a\1\s\output\MOF`, which is a symptom, not the cause.
- Cause: `da590d5` (PR #47) added `- build` as the first step of the `test`
  workflow in `build.yaml`. That job runs `./build.ps1 -tasks test` with
  `pwsh: false`, so `build` → `TestPowerShell7` hard-errors on 5.1.
- The Test-stage jobs already download the `output` pipeline artifact produced
  by the Build stage, so they must not rebuild. Builds `694`, `920` and `1001`
  were green with the pre-`da590d5` workflow.
- Build `1287` (`da590d5`) also failed the `Windows (PowerShell)` job; PR #49
  (`c1f5098`, "Corrected Test Files") fixed that one, leaving only the 5.1 job.
- `Pester_Tests_Stop_On_Fail` in Sampler 0.120.1 depends only on
  `Import_Pester, Invoke_Pester_Tests_v4, Invoke_Pester_Tests_v5,
  Upload_Test_Results_To_AppVeyor, Pester_Run_Times,
  Fail_Build_If_Pester_Tests_Failed` — no build task.
- The Azure DevOps project `randree/e2d948b7-276d-46eb-bbbd-14947dc4fa6a` is
  public; its build, timeline and log REST endpoints answer anonymously.

## Next step

Push the fix branch and confirm the `Windows (Windows PowerShell)` job reaches
Pester and publishes `output/MOF` again.
