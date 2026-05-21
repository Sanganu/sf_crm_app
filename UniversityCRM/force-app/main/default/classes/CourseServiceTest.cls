@isTest
private class CourseServiceTest {

    @isTest static void creates_course() {
        Test.startTest();
        CourseService.createCourse(new List<Course__c>{
            new Course__c(Course_Name__c='Math 101', Code__c='M101')
        });
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Course__c WHERE Code__c='M101']);
    }

    @isTest static void rejects_missing_name() {
        try {
            CourseService.createCourse(new List<Course__c>{ new Course__c(Code__c='X') });
            System.assert(false);
        } catch (CourseService.CourseException e) {
            System.assert(e.getMessage().contains('Name'));
        }
    }

    @isTest static void rejects_missing_code() {
        try {
            CourseService.createCourse(new List<Course__c>{ new Course__c(Course_Name__c='X') });
            System.assert(false);
        } catch (CourseService.CourseException e) {
            System.assert(e.getMessage().contains('Code'));
        }
    }
}