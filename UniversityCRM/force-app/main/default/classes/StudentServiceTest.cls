@isTest private class StudentServiceTest {

    @TestSetup
    //Create Test data
    static void makeData(){
        List<Student__c> studentsList = new List<Student__c>();
        for(Integer i =0;i < 5; i++){
            studentsList.add(new Student__c(
                Name__c = 'First'+(i+2),
                Last_Name__c='LNStore'+(i+10),
                Email__c = 'e'+'First_LNStore'+i+'@gtest.com',
                GPA__c = 3*0.2 +1
            ));
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
            StudentService.validateStudent(new List<Student__c>{
                new Student__c(Name__c='Jasmine',Last_Name__c='Monsoon', GPA__c = 3.9)});
            System.assert(false,'Validations expectations');
        }catch(StudentService.StudentException e){
            System.assert(e.getMessage().contains('Email'));
        }
    }

    @isTest static void gpaValidation(){
        try{
            StudentService.validateStudent(new List<Student__c>{
                new Student__c(
                    Name__c='Himachal',
                    Last_Name__c='Spring',
                    Email__c ='spring@seasons.com',
                    GPA__c=-9)});
      
            System.assert(false,'Expected GPA validation exception');
            }catch(StudentService.StudentException e){
                 System.assertEquals(
            'GPA must be between 0 and 4',
            e.getMessage()
        );
            }
    
    }
     
    @isTest static void validStudentEntry(){
        StudentService.validateStudent(new List<Student__c>{
            new Student__c(Name__c='Apple',
            Last_Name__c = 'Banana',
            Email__c ='Apple@fruits.com',
            GPA__c=3.6)});
        System.assert(true);
    }

    @isTest  static void testGetStudents() {

        Student__c s = new Student__c(
            Name__c='Sita',
            Last_Name__c='Ram',
            Email__c = 'john@test.com',
            GPA__c = 3.5,
            Status__c = 'Active'
        );

        insert s;

        Test.startTest();

        List<Student__c> result = StudentService.getStudents(10);

        Test.stopTest();

        System.assert(result.size() > 0);
    }

    @isTest static void testCreateStudent(){
        Student__c newStudent = new Student__c(
            Name__c = 'Abirami',
            Last_Name__c = 'Somanadar',
            Email__c = 'Ambal@kailash.dev',
            GPA__c = 4.0,
            Status__c = 'Active'
        );
        Test.startTest();
        Id studentId = StudentService.createStudent(newStudent);
        Test.stopTest();
       System.assertEquals(1, [SELECT COUNT() FROM Student__c WHERE Id=:studentId]);
    }

    @isTest
    static void testValidation() {
        Boolean exceptionThrown = false;
       List<Student__c> s = new List<Student__c>{
            new Student__c(
            Name__c='Ram',
            Last_Name__c='Dasarathan',
            Email__c='badGPAData@test.com',
            GPA__c = 20)
        };
        try{
            Test.startTest();
            StudentService.validateStudent(s);
            Test.stopTest();
        }catch(Exception e){
            exceptionThrown = true;
            System.assertEquals('GPA must be between 0 and 4',e.getMessage());
        }
        System.assert(exceptionThrown, 'Expected StudentException to be thrown');
           
        

       }
}