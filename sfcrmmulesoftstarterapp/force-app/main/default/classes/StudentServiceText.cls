@isTest
private class StudentServiceTest {

    @isTest
    static void testGetStudents() {

        Student__c s = new Student__c(
            Name = 'John Doe',
            Email__c = 'john@test.com',
            GPA__c = 8,
            Status__c = 'Active'
        );

        insert s;

        Test.startTest();

        List<Student__c> result = StudentService.getStudents();

        Test.stopTest();

        System.assert(result.size() > 0);
    }

    @isTest
    static void testValidation() {

        Student__c s = new Student__c(
            Name = 'Bad Student',
            GPA__c = 20
        );

        try {

            StudentService.validateStudent(s);

            System.assert(false);

        } catch (Exception e) {

            System.assertEquals(
                'Email is required',
                e.getMessage()
            );
        }
    }
}