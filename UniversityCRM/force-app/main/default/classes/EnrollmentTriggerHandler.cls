public with sharing class EnrollmentTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        setEnrollmentDate((List<Enrollment__c>) Trigger.new);
    }
    protected override void beforeUpdate() {
        validateStatusChange(
            (List<Enrollment__c>) Trigger.new,
            (Map<Id, Enrollment__c>) Trigger.oldMap
        );
    }


    // beforeDelete, afterUpdate, afterDelete — not overridden
    // → empty {} in base class fires, nothing happens 

    // ── private logic methods ──────────────────────────────

    private static void setEnrollmentDate(List<Enrollment__c> recs) {
        for (Enrollment__c e : recs)
            e.Enrollment_Date__c = System.today();
    }

    private static void validateStatusChange(
        List<Enrollment__c> newRecs,
        Map<Id, Enrollment__c> oldMap
    ) {
        for (Enrollment__c e : newRecs) {
            Enrollment__c old = oldMap.get(e.Id);
            if (old.Status__c == 'Completed' && e.Status__c != 'Completed')
                e.addError('Cannot revert a Completed enrollment.');
        }
    }

}