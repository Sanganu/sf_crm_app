trigger Tri_Enrollment_Date on Enrollment__c 
(before insert, before update,
after insert,after update) {
 new EnrollmentTriggerHandler().run();
}