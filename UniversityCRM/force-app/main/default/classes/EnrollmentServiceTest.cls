@isTest
public class EnrollmentServiceTest {

    @TestSetup
    static void makeData(){
        List<Student__c> studentsList = new List<Student__c>();
        List<Course__c> courseList = new List<Course__c>();
        for(Integer i=0;i<5;i++){
            studentsList.add(new Student__c(
                Name__c = 'Ram avatar'+(i+3),
                Last_Name__c = 'Dasarathan'+(i+10),
                Email__c ='st_em'+i+'@gtest.com',
                GPA__c = 2.9+i*0.2
            ));
            courseList.add(new Course__c(
                Name__c = 'Sub-'+i,
                Course_Name__c = 'Sub-'+i,
                Code__c = 'CO-'+i
            ));
        }
        insert studentsList;
        insert courseList;
        System.assertEquals(5, [SELECT COUNT() FROM Student__c]);
        System.assertEquals(5,[SELECT COUNT() FROM Course__c]);
    }

    @isTest static void validateNullEnrollment() {
        System.Test.startTest();
        try {
            EnrollmentService.enrollStudents(null,null);
            System.assert(false, 'Expected enrollment validation exception');
        }catch(EnrollmentService.EnrollmentException e){
            System.assert(e.getMessage().contains('required'));
        }

        System.Test.stopTest();
    }

    @isTest static void validateEmptyEnrollment() {
        System.Test.startTest();
        try {
            EnrollmentService.validateEnrollments(new List<Enrollment__c>{
                new Enrollment__c()
            });
            System.assert(false, 'Expected enrollment validation exception');
        } catch (EnrollmentService.EnrollmentException e) {
            System.assertEquals('Student is required', e.getMessage());
        }
        System.Test.stopTest();
    }
    

    @isTest static void getLimitedEnrollments() {
        List<Id> studentIds = new List<Id>();
        for (Student__c student : [SELECT Id FROM Student__c LIMIT 3]) {
            studentIds.add(student.Id);
        }
        Id courseId = [SELECT Id FROM Course__c LIMIT 1].Id;

        System.Test.startTest();
        EnrollmentService.enrollStudents(studentIds, courseId);
        List<Enrollment__c> recordCount = EnrollmentService.getEnrollments();
        System.Test.stopTest();
        System.assertEquals(3, recordCount.size());
    }
  
}