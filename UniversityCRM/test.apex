Enrollment__c e = [SELECT Id, Status__c FROM Enrollment__c LIMIT 1];
System.debug('Before: ' + e.Status__c);
e.Status__c = (e.Status__c == 'Dropped') ? 'Enrolled' : 'Dropped';
update e;
System.debug('After: ' + e.Status__c);