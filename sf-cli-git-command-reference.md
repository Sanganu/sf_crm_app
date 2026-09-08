# Salesforce CLI & Git Command Reference

Deduplicated command list for deploy/retrieve workflows, local testing, and git cleanup — sorted from **most used → least used** in a typical dev cycle.

## ⚠️ Before you deploy/retrieve: the `force-app` risk

Running `sf project deploy start` or `sf project retrieve start` with **no `--source-dir` or `--metadata` flag** acts on the *entire* default package (or pulls *every* org default). This can silently:
- Overwrite Profiles, Permission Sets, Layouts, or Flows you didn't mean to touch
- Pull down metadata you don't have locally tracked, bloating your repo
- Make it hard to isolate what actually changed in a deploy

**Safer pattern:** scope every deploy/retrieve to a folder, file, or `--metadata` type (rows 5, 6, 13–16, 22–23 below) instead of the bare command, especially against Production or shared Sandboxes.

## Salesforce CLI — Deploy, Retrieve & Test

| # | Command | Scope | Purpose |
|---|---------|-------|---------|
| 1 | `sf org login web --alias DevOrg` | Auth | Authenticates to an org via browser and saves it under an alias for reuse in later commands. |
| 2 | `sf org list` | Auth | Lists all orgs connected to the CLI and flags which one is the default. |
| 3 | `sf config set target-org DevOrg` | Auth | Sets a default org so you don't need `--target-org` on every command. |
| 4 | `sf project deploy start` | Entire project | Deploys the whole local project (defaults to `force-app`). Convenient, but see the warning above — pushes every metadata type at once. |
| 5 | `sf project deploy start --source-dir force-app/main/default/classes` | Folder/type only | Deploys just one metadata folder (e.g. all Apex classes), keeping flows/layouts/profiles untouched. |
| 6 | `sf project deploy start --source-dir force-app/main/default/classes/StudentService.cls` | Single file | Deploys one file in isolation — the safest way to test a single change. |
| 7 | `sf project retrieve start --source-dir force-app` | Entire project (scoped) | Pulls everything under your local `force-app` folder, but not unrelated org-wide defaults. |
| 8 | `sf project retrieve start` | Entire project (full) | Pulls **everything**, including org defaults not yet tracked locally — broadest and riskiest retrieve. |
| 9 | `sf apex run test --test-level RunLocalTests` | Tests (local) | Runs every test class in your namespace, excluding managed-package tests. Typically run before a deploy. |
| 10 | `sf apex run test --class-names StudentServiceTest --target-org DevOrg` | Tests (single class) | Runs only one named test class — fastest option while iterating. |
| 11 | `sf project deploy start --source-dir force-app --test-level RunLocalTests --dry-run --target-org DevOrg` | Validation | Validates the deploy and runs local tests **without** actually deploying — a pre-flight check. |
| 12 | `sf apex get test --test-run-id 707... --target-org DevOrg` | Tests (results) | Fetches pass/fail results and code coverage for an asynchronous test run by its ID. |
| 13 | `sf project retrieve start --metadata ApexTrigger:YourTriggerName` | Triggers only | Retrieves a single Apex Trigger by name — useful when a trigger was created/edited directly in Setup. |
| 14 | `sf project retrieve start --metadata Flow` | Flows only | Retrieves all Flow metadata from the org. |
| 15 | `sf project retrieve start --manifest manifest/package.xml` | Manifest-based | Retrieves exactly the components listed in `package.xml` — the most precise, repeatable retrieve method. |
| 16 | `sf apex run --file scripts/apex/demo.apex` | Ad-hoc execution | Runs an anonymous Apex script file against the org, equivalent to "Execute Anonymous" in Developer Console. |
| 17 | `sf apex run` | Ad-hoc execution | Opens an interactive prompt to paste anonymous Apex and run it (`Ctrl+D` / `Ctrl+Z` to execute). |
| 18 | `sf org open` | Auth | Opens the default (or specified) org directly in your browser. |
| 19 | `sf org logout --target-org DevOrg` | Auth | Logs out of one specific org/alias. |
| 20 | `sf org logout --all` | Auth | Logs out of every connected org at once. |
| 21 | `sf org create scratch --definition-file config/project-scratch-def.json` | Safe testing | Spins up a disposable scratch org so you can deploy/test before touching a real sandbox or Production. |
| 22 | `sf project retrieve start --metadata "CustomObject:Integration_Log__c"` | Object only | Retrieves a single custom object's metadata. |
| 23 | `sf project retrieve start --metadata "Report:unfiled$public/YourReportName"` | Report only | Retrieves one specific report by its folder/name path. |
| 24 | `sf force lightning dev` | LWC local preview | Runs a local dev server to preview a Lightning Web Component in the browser without deploying it to the org. |
| 25 | `sf project retrieve start --source-dir force-app/main/defau git
|---|---------|---------|
| 1 | `git status` | Shows staged, unstaged, and untracked files — always check this before any cleanup action. |
| 2 | `git diff` | Shows the exact line-by-line changes not yet staged. |
| 3 | `git restore <file>` | Discards uncommitted changes in a file, reverting it to the last commit. (Older equivalent: `git checkout -- <file>`.) |
| 4 | `git stash` | Temporarily shelves uncommitted changes so you can switch branches/context cleanly. |
| 5 | `git stash pop` | Re-applies the most recently stashed changes. |
| 6 | `git reset --soft HEAD~1` | Undoes the last commit but keeps the changes staged — a safe way to "redo" a commit. |
| 7 | `git reset --hard HEAD` | Discards **all** uncommitted local changes, resetting to the last commit. Destructive — use carefully. |
| 8 | `git clean -fd` | Deletes untracked files and directories (build artifacts, junk files). Irreversible. |
| 9 | `git revert <commit-hash>` | Creates a new commit that undoes a previous one — safe for commits already pushed/shared. |
| 10 | `git log --oneline` | Quick commit history view, useful for finding a hash to reset or revert to. |
| 11 | `git branch -d <branch-name>` | Deletes a local branch that's already merged, for cleanup. |



Mulesoft - Supabase:

mvn clean install -DskipTests  