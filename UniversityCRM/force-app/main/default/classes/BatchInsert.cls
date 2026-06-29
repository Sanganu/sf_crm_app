global class BatchInsert implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, Status__c, Student__c, Course__c ' +
            'FROM Enrollment__c ' +
            'WHERE Status__c = null OR Status__c = \'New\''
        );
    }

    global void execute(Database.BatchableContext bc, List<Enrollment__c> scope) {
        List<Enrollment__c> toUpdate = new List<Enrollment__c>();
        for (Enrollment__c enr : scope) {
            enr.Status__c = 'Active';
            toUpdate.add(enr);
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('BatchInsert complete — Enrollments activated');
    }
}