@isTest
private class CourseServiceTest {

    @isTest static void creates_course() {
        Test.startTest();
        CourseService.createCourse(new List<Course__c>{
            new Course__c(Name__c='Math 101', Course_Name__c='Math 101', Code__c='M101',Max_Capacity__c=3)
        });
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Course__c WHERE Code__c='M101']);
    }

    @isTest static void create_course_list(){
        List<Course__c> course_list = new List<Course__c>{
            new Course__c(Name__c='CHEM 101',Course_Name__c='Chemistry Fundamentals 101',Code__c='CH101',Max_Capacity__c=30),
            new Course__c(Name__c='PHY 105',Course_Name__c='Physics Fundamentals 105',Code__c='PH105',Max_Capacity__c=25),
            new Course__c(Name__c='BIO 115',Course_Name__c='Biology Fundamentals 115',Code__c='BI115',Max_Capacity__c=27)
        };
        Test.startTest();
        CourseService.createCourse(course_list);
        Test.stopTest();
          System.assertEquals(3, [SELECT COUNT() FROM Course__c],'Expected 3 courses inserted');
    }

    //Bulk Test
    @isTest static void bulk_insert_200_records(){
        List<Course__c> courses = new List<Course__c>();
        for(Integer i=0;i<200;i++){
            courses.add(new Course__c(
                Name__c = 'Course --'+(i+1),
                Course_Name__c ='Course Name --'+(i+1),
                Code__c = 'C'+(i+1*100/10),
                Max_Capacity__c = 20
            ));
        }
        Test.startTest();
        CourseService.createCourse(courses);
        Test.stopTest();
        System.assertEquals(200,[SELECT COUNT() FROM Course__c],'Expected 200 Courses');
    }

    //Null Validation
    @isTest static void whenNullInputValidation(){
        Test.startTest();
        CourseService.validateCourse(null);
        Test.stopTest();
        System.assert(true,'Null list input handled gracefully');
    }

    //Empty Data
    @isTest static void emptyInputValidation(){
        Test.startTest();
        CourseService.validateCourse(new List<Course__c>());
        Test.stopTest();
        System.assert(true,'Empty list input handled gracefully');
    }

    //Validation - Name__c
    @isTest static void rejects_missing_name() {
        try {
            CourseService.createCourse(new List<Course__c>{
                new Course__c(Course_Name__c='Course X', Code__c='X',Max_Capacity__c=4)
            });
            System.assert(false,'Except course Expectation for missing Name__C');
        } catch (CourseService.CourseException e) {
            System.assert(e.getMessage().contains('Name'),'Exception message should mention Name');
        }
    }


    //Validation - missing Course code
    @isTest static void rejects_missing_code() {
        try {
            CourseService.createCourse(new List<Course__c>{
                new Course__c(Name__c='XCourse', Course_Name__c='Course X',Max_Capacity__c=3)
            });
            System.assert(false,'Course code is missing');
        } catch (CourseService.CourseException e) {
           System.assert(
                e.getMessage().contains('Course Code'),
                e.getMessage()
            );
        }
    }

     //Validation - missing  Course Name
    @isTest static void rejects_missing_course_name() {
        try {
            CourseService.createCourse(new List<Course__c>{
                new Course__c(Name__c='Course XY', Course_Name__c='',Max_Capacity__c=3,Code__C='XY101')
            });
            System.assert(false,'Course Name is missing');
        } catch (CourseService.CourseException e) {
            System.assertEquals(
                'Course Name is required',
                e.getMessage()
            );
        }
    }

    //batch insert - second data is bad - should revert
    @isTest static void rejects_bulks_insert(){
        List<Course__c> courses =  new List<Course__c>{
               new Course__c(Name__c='CHEM 101',Course_Name__c='Chemistry Fundamentals 101',Code__c='CH101',Max_Capacity__c=30),
               new Course__c(Course_Name__c='Course X',Max_Capacity__c=3,Code__c='B101')
            };
        try{
            CourseService.createCourse(courses);
            Assert.fail('Expected CourseException for invalid record in bulk list');
        }catch(CourseService.CourseException e){
             System.assert(e.getMessage().contains('Name'), 'Exception should mention missing Name');
        }
        System.assertEquals(0, [SELECT COUNT() FROM Course__c], 'No records should be inserted when validation fails');
    }
}