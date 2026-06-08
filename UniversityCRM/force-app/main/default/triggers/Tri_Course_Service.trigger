trigger Tri_Course_Service on Enrollment__c (before insert, before update) {
 new CourseServiceTriggerHandler().run();
}