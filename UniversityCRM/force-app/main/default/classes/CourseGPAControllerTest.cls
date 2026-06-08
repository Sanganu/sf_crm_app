@isTest
private class CourseGPAControllerTest {

    @isTest
    static void testGetCourseAverageGrades() {
        Course__c course = new Course__c(
            Name__c = 'Math 101',
            Course_Name__c = 'Math 101',
            Code__c = 'M101',
            Max_Capacity__c = 30
        );
        insert course;

        Student__c student = new Student__c(GPA__c = 3.5);
        insert student;

        Enrollment__c enrollment = new Enrollment__c(
            Course__c = course.Id,
            Student__c = student.Id,
            Grade__c = 90,
            Status__c = 'Enrolled'
        );
        insert enrollment;

        Test.startTest();
        List<CourseGPAController.CourseGPAData> results = 
            CourseGPAController.getCourseAverageGrades();
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one course');
        System.assertEquals('Math 101', results[0].courseName, 'Course name should match');
        System.assertEquals(90, results[0].avgGrade, 'Average grade should be 90');
    }

    @isTest
    static void testNoEnrollments() {
        Test.startTest();
        List<CourseGPAController.CourseGPAData> results = 
            CourseGPAController.getCourseAverageGrades();
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return empty list when no enrollments');
    }

    @isTest
    static void testMultipleCourses() {
        Course__c c1 = new Course__c(
            Name__c = 'Math 101', Course_Name__c = 'Math 101',
            Code__c = 'M101', Max_Capacity__c = 30
        );
        Course__c c2 = new Course__c(
            Name__c = 'Science 101', Course_Name__c = 'Science 101',
            Code__c = 'S101', Max_Capacity__c = 30
        );
        insert new List<Course__c>{ c1, c2 };

        Student__c student = new Student__c(GPA__c = 3.5);
        insert student;

        insert new List<Enrollment__c>{
            new Enrollment__c(Course__c = c1.Id, Student__c = student.Id,
                Grade__c = 85, Status__c = 'Enrolled'),
            new Enrollment__c(Course__c = c2.Id, Student__c = student.Id,
                Grade__c = 92, Status__c = 'Enrolled')
        };

        Test.startTest();
        List<CourseGPAController.CourseGPAData> results = 
            CourseGPAController.getCourseAverageGrades();
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Should return two courses');
    }
}