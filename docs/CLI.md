```bash
sf org list
```

```bash
sf org login web --alias DevOrg
```

```bash
$ sf apex run test --test-level RunLocalTests --synchronous
```

```bash
 sf config set target-org DevOrg
 ```

```bash
sf project deploy start
```

```bash
sf project deploy start --source-dir force-app/main/default/classes
```

```bash
sf apex run test --test-level RunLocalTests
```

```bash
sf project retrieve start
```

```bash
sf project retrieve start --source-dir force-app
```


To run your Apex **classes and tests** in the CLI, you mainly use two commands:

```bash
sf apex run test
```
and
```bash
sf apex run
```

Here’s how to use them in sequence.

***

### 1. Make sure you’re in the right folder

Open a terminal in your Salesforce DX project:

```bash
cd salesforce-crm-dev-starter
```

***

### 2. Login (if not already)

```bash
sf org login web
```

Then choose your org and log in.

***

### 3. Run a specific Apex test class

Assume your class is:
- `StudentServiceTest.cls`

Run it with:

```bash
sf apex run test --class-names StudentServiceTest --target-org yourOrgAlias
```

Example:
```bash
sf apex run test --class-names StudentServiceTest --target-org DevOrg
```

That runs only that test class in your org. [github](https://github.com/salesforcecli/plugin-apex)

***

### 4. Get the test results

The previous command outputs something like:

```text
sf apex get test --test-run-id 707...
```

Copy that line and run it:

```bash
sf apex get test --test-run-id 707... --target-org DevOrg
```

That shows the test pass/fail result and code coverage details. [developer.salesforce](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_testing.htm)

***

### 5. Run anonymous Apex from CLI (optional)

If you want to call methods or test logic ad‑hoc:

```bash
sf apex run
```

Then type:

```apex
StudentService.getStudents();
```

Press `Ctrl+D` (or `Ctrl+Z` on Windows) to send it to Salesforce.

You can also put code in a file:

```bash
sf apex run --file scripts/apex/demo.apex
```

That runs the Apex file as an anonymous block. [developer.salesforce](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_develop_apex_run_anon.htm)

***

### 6. If you want to run ALL tests

```bash
sf apex run test --target-org DevOrg
```

That runs every test class in the org. [developer.salesforce](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm)

***

### Quick checklist for your CLI flow

```bash
sf org login web
sf apex run test --class-names StudentServiceTest --target-org DevOrg
sf apex get test --test-run-id 707... --target-org DevOrg
```

If you tell me your org alias and test class name, I can write the **exact ready‑to‑paste** commands for you to run in one shot.