trigger Tri_Course_Service on Course__c (
    before insert, before update,
    after insert,  after update
) {
    new CourseServiceTriggerHandler().run();
}