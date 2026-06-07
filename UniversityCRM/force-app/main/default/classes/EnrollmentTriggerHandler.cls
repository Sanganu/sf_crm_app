public with sharing class EnrollmentTriggerHandler extends TriggerHandler {

    protected override void beforeInsert() {
        setEnrollmentDate((List<Enrollment__c>) Trigger.new);
        checkCapacityAndWaitlist((List<Enrollment__c>) Trigger.new); // ← was missing
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
            update as user enrollStudent.values();
            sendEnrollmentEmails(enrollStudent.values()); // ← added semicolon
        }
    }

    // ── 5. Send email on promotion ─────────────────────────

    private static void sendEnrollmentEmails(List<Enrollment__c> newEnrollments) {
        List<Messaging.SingleEmailMessage> emails =  // ← fixed variable name
            new List<Messaging.SingleEmailMessage>();

        for (Enrollment__c e : newEnrollments) {
            if (e.Student__r.Email__c == null) continue;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); // ← added semicolon
            mail.setToAddresses(
                new List<String>{ e.Student__r.Email__c } // ← fixed String typo
            );
            mail.setSubject(
                'Congrats! You have been enrolled in ' + e.Course__r.Name
            );
            mail.setPlainTextBody(
                'Hi ' + e.Student__r.Name + ',\n\n' +
                'Great news! A seat has opened up and you have been moved from ' +
                'the waitlist to enrolled.\n\n' +
                'Please meet your counsellor to discuss your credits and classes.\n\n' +
                'University CRM Team'
            );
            emails.add(mail);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}

// public with sharing class EnrollmentTriggerHandler extends TriggerHandler{
//     protected override void beforeInsert(){
//         setEnrollmentDate((List<Enrollment__c>) Trigger.new);
//     }
//     protected override void beforeUpdate() {
//         validateStatusChange(
//             (List<Enrollment__c>) Trigger.new,
//             (Map<Id, Enrollment__c>) Trigger.oldMap
//         );
//     }
//    //  adding after Update  - because when student drops - need to commit that change and then
//    // check the waitlist and enroll the new student
//    protected override void afterUpdate(){
//     enrollFromWaitlist((List<Enrollment__c>) Trigger.new, (Map<Id,Enrollment__C>) Trigger.oldMap)
//    }

//     // beforeDelete, afterUpdate, afterDelete — not overridden
//     // → empty {} in base class fires, nothing happens 

//     // ── private logic methods ──────────────────────────────

//     private static void setEnrollmentDate(List<Enrollment__c> recs) {
//         for (Enrollment__c e : recs)
//             e.Enrollment_Date__c = System.today();
//     }

//     private static void validateStatusChange(
//         List<Enrollment__c> newRecs,
//         Map<Id, Enrollment__c> oldMap
//     ) {
//         for (Enrollment__c e : newRecs) {
//             Enrollment__c old = oldMap.get(e.Id);
//             if (old.Status__c == 'Completed' && e.Status__c != 'Completed')
//                 e.addError('Cannot revert a Completed enrollment.');
//             if (old.Status__c == 'Rejected' && e.Status__c != 'Rejected')
//                 e.addError('Cannot revert a Rejected enrollment');
//         }
//     }

//     private static void checkCapacityAndWaitlist(List<Enrollment__c> recs){
//         Set<Id> courserIds = new Set<Id>();
//         for (Enrollment__c e : recs){
//             if(e.Course))c !==null)courserIds.add(e.Course__c);
//         }
//         Map<Id,Course__c> courseMap = new Map<Id,Course__c>([
//             SELECT Id, Max_Capacity__c, Total_students_enrolled__c from Course__c
//             WHERE Id IN :courserIds
//         ]);
//         for(Enrollment__c e:recs){
//             if(e.Course__c == null)continue;

//             Course__c course =courseMap.get(e.Course__c)
//             if(course == null)continue;
//             Decimal enrolled = course.Total_students_enrolled__c ?? 0;
//             Decimal maxCapacity = course.Max_Capacity__c ?? 0;
//             if(enrolled >= maxCapacity){
//                 e.Status__c = 'Waitlisted';
//             }else{
//                 e.Status__c = 'Enrolled';
//             }
//         }
//     }

//     private static void enrollFromWaitlist(
//         List<Enrollment__c> newRecs,
//         Map<Id,Enrollment__c> oldMap
//     ){
//         Set<Id> droppedCourseIds = new Set<Id>();
//         for(Enrollment__c e: newRecs){
//             Enrollment__c eOld = oldMap.get(e.Id);
//             if(eold.Status__c == 'Enrolled' && 
//             (e.Status__c == 'Dropped' || e.Status__c == 'Cancelled')){
//                 droppedCourseIds.add(e.Course__c);
//             }
//         }
//         if(droppedCourseIds.isEmpty()) return;

//         List<Enrollment__c> waitlisted = [ 
//             SELECT Id, Status__c,Course__c,Student__r.Email__c,Student__r.Name,Course__C.Name
//             FROM Enrollment__c
//             WHERE Course__c IN :droppedCourseIds and Status__c = 'Waitlisted'
//             ORDER BY CreatedDate ASC];
            
//         //waitlist to enroll
//         Map<Id, Enrollment__c> enrollStudent = new Map<Id, Enrollment__c>();
//         for(Enrollment__c e:waitlisted){
//             if(!enrollStudent.containsKey(e.Course__c)){
//                 e.Status__c = 'Enrolled';
//                 enrollStudent.put(e.Course__c,e);
//             }
//         }

//         if(!enrollStudent.isEmpty()){
//             update as user enrollStudent.values();
//             sendEnrollmentEmails(enrollStudent.values())
//         }

//     }

//     private static void sendEnrollmentEmails(
//         List<Enrollment__c> newEnrollments
//     ){
//         List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
//         for(Enrollment__c e: newEnrollments){
//             if(e.Student__r.Email__c == null) continue;
//             Messaging.SingleEmailMessage   mail = new Messaging.SingleEmailMessage()
//             mail.setToAddresses(
//                 new List<Stirng>{e.Student__r.Email__c}
//             );
//             mail.setSubject(
//                 'Congrats,You have been enrolled for this course '+e.Course__r.Name
//             );
//             mail.setPlainTextBody(
//                 'Hi'+e.Student__r.Name+', '+'\n\n'+
//                 'Great news! We had a seat opened up and you have been moved to enrollment.\n\n'+
//                 'Please meet your counsellor to further discuss about your classes'
//             );
//             emails.add(mail);
//         }
//         if(!emails.isEmpty()){
//             Messaging.sendEmail(emails);
//         }
//     }
// }