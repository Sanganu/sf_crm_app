sf org list
sf org login web --alias DevOrg
 sf config set target -org DevOrg
sf project deploy start
sf project deploy start --source-dir force-app/main/default/classes
sf apex run test --test-level RunLocalTests
 