@isTest private class StudentTriggerHandlerTest{
    @isTest
    static void testGpaStatus(){
        List<Student__c> students = new List<Student__c>{
            new Student__c(GPA__c = 3.8),
            new Student__c(GPA__c = 2.0)
        };
            StudentTriggerHandler.applyStatusFromGpa(students);

        System.assertEquals('Active', students[0].Status__c);
        System.assertEquals('New',    students[1].Status__c);
    }

    @isTest
    static void testNullInput(){
        StudentTriggerHandler.applyStatusFromGpa(null);
        System.assert(true);
    }
}