@isTest
private class StudentServiceTest {

    @TestSetup
    //Create Test data
    static void makeData(){
        List<Student__c> studentsList = new List<Student__c>();
        for(Integer i =0;i < 5; i++){
            studentsList.add(new Student__c(
                Name__c = 'First'+(i+2),
                Last_Name__C 'LNStore'+(i+10),
                Email__C = 'e'+'First_LNStore'+i+'@gtest.com',
                GPA__c = 3*0.2 +1
            ))
        }
        insert studentsList;

    }

     @isTest static void getStudents_returns_rows_limited() {
        Test.startTest();
        List<Student__c> r = StudentService.getStudents(3);
        Test.stopTest();
        System.assertEquals(3, r.size());
    }

    @isTest static void emailValidation(){
        try{
            StudentService.validateStudents(new List<Student__c>{
                new Student__c(Name__c='Jasmine',Last_Name='Monsoon', GPA--c = 3.9)
            });
            System.assert(false,'Validations expectations')
        }catch(StudentService.StudentValidationException e){
            System.assert(e.getMessage().contains('Email'))
        }
    }

    @isTest static void gpaValidation(){
        try{
            StudentService.validationStudents(new List<Student__c>{
                new Student__c(Name__C='Himachal',Last_Name__c='Spring'
                ,Email__c ="spring@seasons.com",GPA__c="-9")});
            }
        catch(StudentService.StudentValidationException e){
            System.assert(e.getMessage().contains('GPA'));
        }
    }
     
    @isTest static void validStudentEntry(){
        StudentService.validateStudents(new List<Student__c>{
            new Student__C(Name__C='Apple',
            Last_Name__c = 'Banana',
            Email__c ='Apple@fruits.com',
            GPC__c=3.6)
        });
        System.assert(true);
    }
    @isTest  static void testGetStudents() {

        Student__c s = new Student__c(
            Name__c='Sita',
            Last_Name__c='Ram',
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
            Name__c='Ram',
            Last_Name__c='  Dasarathan',
            Email__c='badData@test.com',
            GPA__c = 20
        );

        try {

            StudentService.validateStudent(s);

            System.assert(false);

        } catch (Exception e) {

            System.assertEquals(
                'Invalid entry',
                e.getMessage()
            );
        }
    }
}