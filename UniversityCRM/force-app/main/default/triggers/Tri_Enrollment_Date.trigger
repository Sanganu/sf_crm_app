trigger Tri_Enrollment_Date on Enrollment__c (before insert, before update) {
 new EnrollmentTriggerHandler().run();
}