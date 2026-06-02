@isTest
private class CourseServiceTest {

    @isTest static void creates_course() {
        System.Test.startTest();
        CourseService.createCourse(new List<Course__c>{
            new Course__c(Name__c='Math 101', Course_Name__c='Math 101', Code__c='M101')
        });
        System.Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Course__c WHERE Code__c='M101']);
    }

    @isTest static void rejects_missing_name() {
        try {
            CourseService.createCourse(new List<Course__c>{
                new Course__c(Course_Name__c='Course X', Code__c='X')
            });
            System.assert(false);
        } catch (CourseService.CourseException e) {
            System.assert(e.getMessage().contains('Name'));
        }
    }

    @isTest static void rejects_missing_code() {
        try {
            CourseService.createCourse(new List<Course__c>{
                new Course__c(Name__c='Course X', Course_Name__c='Course X')
            });
            System.assert(false);
        } catch (CourseService.CourseException e) {
            System.assert(e.getMessage().contains('Code'));
        }
    }
}