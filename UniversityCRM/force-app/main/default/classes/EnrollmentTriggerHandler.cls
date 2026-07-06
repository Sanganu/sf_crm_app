public with sharing class EnrollmentTriggerHandler extends TriggerHandler {
    
    protected override void beforeInsert() {
        setEnrollmentDate((List<Enrollment__c>) Trigger.new);
        checkCapacityAndWaitlist((List<Enrollment__c>) Trigger.new);
    }
    
    protected override void afterInsert() {
        publishEnrollmentChangeEvents((List<Enrollment__c>) Trigger.new, 'INSERT');
    }
    
    protected override void beforeUpdate() {
        validateStatusChange(
            (List<Enrollment__c>) Trigger.new,
        (Map<Id, Enrollment__c>) Trigger.oldMap
            );
    }
    
    // after update — student drops → commit first → then promote from waitlist
    protected override void afterUpdate() {
        enrollFromWaitlist(
            (List<Enrollment__c>) Trigger.new,
        (Map<Id, Enrollment__c>) Trigger.oldMap
            );
        publishEnrollmentChangeEvents(
            (List<Enrollment__c>) Trigger.new,
        (Map<Id, Enrollment__c>) Trigger.oldMap,
        'UPDATE'
            );
    }
    
    // ── 1. Set enrollment date ─────────────────────────────
    
    private static void setEnrollmentDate(List<Enrollment__c> recs) {
        for (Enrollment__c e : recs)
            e.Enrollment_Date__c = System.today();
    }
    
    // ── 2. Capacity check — before insert ─────────────────
    
    private static void checkCapacityAndWaitlist(List<Enrollment__c> recs) {
        Set<Id> courseIds = new Set<Id>();
        for (Enrollment__c e : recs) {
            if (e.Course__c != null) courseIds.add(e.Course__c); // ← fixed typo
        }
        
        Map<Id, Course__c> courseMap = new Map<Id, Course__c>([
            SELECT Id, Max_Capacity__c, Total_Students_Enrolled__c
            FROM Course__c
            WHERE Id IN :courseIds
        ]);
        
        for (Enrollment__c e : recs) {
            if (e.Course__c == null) continue;
            Course__c course = courseMap.get(e.Course__c); // ← fixed typo
            if (course == null) continue;
            
            Decimal enrolled  = course.Total_Students_Enrolled__c ?? 0;
            Decimal maxCap    = course.Max_Capacity__c ?? 0;
            
            if (enrolled >= maxCap) {
                e.Status__c = 'Waitlisted';
            } else {
                e.Status__c = 'Enrolled';
            }
        }
    }
    
    // ── 3. Validate status change — before update ──────────
    
    private static void validateStatusChange(
        List<Enrollment__c> newRecs,
    Map<Id, Enrollment__c> oldMap
    ) {
        for (Enrollment__c e : newRecs) {
            Enrollment__c old = oldMap.get(e.Id);
            
            if (old.Status__c == 'Completed' && e.Status__c != 'Completed')
                e.addError('Cannot revert a Completed enrollment.');
            
            if (old.Status__c == 'Rejected' && e.Status__c != 'Rejected')
                e.addError('Cannot revert a Rejected enrollment.');
        }
    }
    
    // ── 4. Promote from waitlist — after update ────────────
    
    private static void enrollFromWaitlist(
        List<Enrollment__c> newRecs,
    Map<Id, Enrollment__c> oldMap
    ) {
        Set<Id> droppedCourseIds = new Set<Id>();
        for (Enrollment__c e : newRecs) {
            Enrollment__c oldRec = oldMap.get(e.Id); // ← fixed eold → oldRec
            if (oldRec.Status__c == 'Enrolled' &&
            (e.Status__c == 'Dropped' || e.Status__c == 'Rejected')) {
                droppedCourseIds.add(e.Course__c);
            }
        }
        
        if (droppedCourseIds.isEmpty()) return;
        
        List<Enrollment__c> waitlisted = [
            SELECT Id, Status__c, Course__c,
                   Student__r.Email__c, Student__r.Name, Course__r.Name
            FROM Enrollment__c
            WHERE Course__c IN :droppedCourseIds
            AND Status__c = 'Waitlisted'
            ORDER BY CreatedDate ASC
        ];
        
        Map<Id, Enrollment__c> enrollStudent = new Map<Id, Enrollment__c>();
        for (Enrollment__c e : waitlisted) {
            if (!enrollStudent.containsKey(e.Course__c)) {
                e.Status__c = 'Enrolled';
                enrollStudent.put(e.Course__c, e);
            }
        }
        
        if (!enrollStudent.isEmpty()) {
            update  enrollStudent.values();
        }
    }
    
    //adding platform events
    // ── 5. Publish Platform Event — insert ─────────────────
    
    private static void publishEnrollmentChangeEvents(
        List<Enrollment__c> recs,
    String changeType
    ) {
          String txnId = Request.getCurrent().getRequestId();
        List<Enrollment_Change__e> events = new List<Enrollment_Change__e>();
        for (Enrollment__c e : recs) {
            events.add(new Enrollment_Change__e(
                Enrollment_Id__c = e.Id,
            Student_Id__c    = e.Student__c,
            Change_Type__c   = changeType,
            New_Status__c    = e.Status__c,
            Transaction_Id__c = txnId
                ));
        }
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
    
    // ── 5b. Publish Platform Event — update (only when Status__c actually changed) ─
    
    private static void publishEnrollmentChangeEvents(
        List<Enrollment__c> newRecs,
    Map<Id, Enrollment__c> oldMap,
    String changeType
    ) {
        String txnId = Request.getCurrent().getRequestId(); 
        List<Enrollment_Change__e> events = new List<Enrollment_Change__e>();
        for (Enrollment__c e : newRecs) {
            Enrollment__c old = oldMap.get(e.Id);
            if (old.Status__c != e.Status__c) {
                events.add(new Enrollment_Change__e(
                    Enrollment_Id__c = e.Id,
                Student_Id__c    = e.Student__c,
                Change_Type__c   = changeType,
                New_Status__c    = e.Status__c,
                Transaction_Id__c = txnId
                    ));
            }
        }
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
    
}