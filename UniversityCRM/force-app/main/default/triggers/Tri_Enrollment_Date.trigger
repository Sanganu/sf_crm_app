trigger Tri_Enrollment_Date on Enrollment__c (before insert) {
 new EnrollmentTriggerHandler.run()
}