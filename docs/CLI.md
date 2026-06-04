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
# To dry run

sf project deploy start   --source-dir force-app   --test-level RunLocalTests   --dry-run   --target-org DevOrg


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

```bash
# Deploy ONLY one specific file to test it in isolation
sf project deploy start --source-dir force-app/main/default/classes/StudentService.cls

# Deploy a specific folder
sf project deploy start --source-dir force-app/main/default/classes
```

```bash
# login
sf org open
# Re-authenticate
sf org login web --alias agentforce-org

# Or if you know the username
sf org login web --alias agentforce-org \
  --login-url https://login.salesforce.com

  # check
  sf org list --all

 # Logout
 sf org logout --target-org DevOrg

 #Logout All
 sf org logout --all

# Login
sf org login web --alias DevOrg --instance-url https://login.salesforce.com

# No Default Environment

sf project retrieve start --source-dir force-app --target-org DevOrg

````
To run your Apex **classes and tests** in the CLI, you mainly use two commands:

```bash
sf apex run test
```
and
```bash
sf apex run


# To retrieve Triggers created in UI

sf project retrieve start --metadata ApexTrigger:YourTriggerName
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

# retrieve xml
sf project retrieve start --manifest manifest/package.xml


#
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


### LWC
```bash
# Install dependencies first
npm install

# Run local dev server — previews component in browser without deploying
sf force lightning dev
# or
lwc-dev-server
```


```bash

1. LOCAL VALIDATION (catch obvious errors before touching org)
   sf project deploy start --dry-run
   # Shows what would deploy and validates metadata, no actual push

2. DEPLOY TO SCRATCH ORG FIRST (safe sandbox)
   sf org create scratch --definition-file config/project-scratch-def.json
   sf project deploy start

3. ONLY THEN deploy to real sandbox/production

```


# Login via browser
sf org login web --alias myOrg

# Check connected orgs
sf org list

sf apex run test  --target-org DevOrg  --result-format human   --wait 10

# Developer Console version:
# Debug → Open Execute Anonymous Window → paste code → Execute

# CLI version:
sf apex run --file myScript.apex --target-org myOrg

# Or one-liner:
echo "System.debug('Hello!');" | sf apex run --target-org myOrg

# Human readable (default — easiest to read)
--result-format human

# JSON (for scripts / CI pipelines)
--result-format json

# JUnit (for tools like Jenkins)
--result-format junit