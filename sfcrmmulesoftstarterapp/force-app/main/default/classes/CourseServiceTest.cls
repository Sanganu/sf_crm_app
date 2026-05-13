@isTest
private class CourseServiceTest {

    @isTest
    static void testCreateCourse() {

        Course__c c = new Course__c();
        c.Name = 'Math 101';
        c.Code__c = 'M101';
        c.Name__c = 'MATH';

        Test.startTest();

        CourseService.createCourse(c);

        Test.stopTest();

        List<Course__c> result = [
            SELECT Id, Name, Code__c
            FROM Course__c
            WHERE Name = 'Math 101'
        ];

        System.assertEquals(1, result.size());
    }

    @isTest
    static void testValidation() {

        Course__c c = new Course__c();

        try {
            CourseService.createCourse(c);
            System.assert(false);
        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('Course Name is required')
            );
        }
    }
}