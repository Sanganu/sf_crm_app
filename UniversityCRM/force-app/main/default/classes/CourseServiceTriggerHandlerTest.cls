@isTest
private class CourseServiceTriggerHandlerTest {

    //Insert

    @isTest
    static void insert_valid_course_succeeds() {
        Test.startTest();
        insert new Course__c(
            Name__c = 'Math 101',
            Course_Name__c = 'Mathematics',
            Code__c = 'M101',
            Max_Capacity__c = 30
        );
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Course__c WHERE Code__c = 'M101']);
    }

    @isTest
    static void insert_sets_default_max_capacity() {
        Test.startTest();
        insert new Course__c(
            Name__c = 'Bio 101',
            Course_Name__c = 'Biology',
            Code__c = 'B101'
            // Max_Capacity__c intentionally omitted
        );
        Test.stopTest();

        Course__c result = [SELECT Max_Capacity__c FROM Course__c WHERE Code__c = 'B101'];
        System.assertEquals(25, result.Max_Capacity__c, 'Default capacity should be 25');
    }

    @isTest
    static void insert_sets_default_is_active() {
        Test.startTest();
        insert new Course__c(
            Name__c = 'Chem 101',
            Course_Name__c = 'Chemistry',
            Code__c = 'CH101'
            // Is_Active__c intentionally omitted
        );
        Test.stopTest();

        Course__c result = [SELECT Is_Active__c FROM Course__c WHERE Code__c = 'CH101'];
        System.assertEquals(true, result.Is_Active__c, 'Is Active should default to true');
    }

    @isTest
    static void insert_rejects_missing_name() {
        try {
            insert new Course__c(
                Course_Name__c = 'Mathematics',
                Code__c = 'M101',
                Max_Capacity__c = 30
            );
            System.assert(false, 'Should have thrown an exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Name'), 'Error should mention Name');
        }
    }

    @isTest
    static void insert_rejects_missing_course_name() {
        try {
            insert new Course__c(
                Name__c = 'Math 101',
                Code__c = 'M101',
                Max_Capacity__c = 30
            );
            System.assert(false, 'Should have thrown an exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('course name'), 'Error should mention Course Name');
        }
    }

    @isTest
    static void insert_rejects_missing_code() {
        try {
            insert new Course__c(
                Name__c = 'Math 101',
                Course_Name__c = 'Mathematics',
                Max_Capacity__c = 30
            );
            System.assert(false, 'Should have thrown an exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('code'), 'Error should mention Code');
        }
    }

    @isTest
    static void insert_rejects_invalid_date_range() {
        try {
            insert new Course__c(
                Name__c = 'Math 101',
                Course_Name__c = 'Mathematics',
                Code__c = 'M101',
                Course_Start_Date__c = Date.today(),
                Course_End_Date__c = Date.today().addDays(-1) // end before start
            );
            System.assert(false, 'Should have thrown an exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('End Date'), 'Error should mention End Date');
        }
    }

    // Update

    @isTest
    static void update_valid_course_succeeds() {
        Course__c course = new Course__c(
            Name__c = 'Math 101',
            Course_Name__c = 'Mathematics',
            Code__c = 'M101',
            Max_Capacity__c = 30
        );
        insert course;

        Test.startTest();
        course.Course_Name__c = 'Advanced Mathematics';
        update course;
        Test.stopTest();

        Course__c result = [SELECT Course_Name__c FROM Course__c WHERE Id = :course.Id];
        System.assertEquals('Advanced Mathematics', result.Course_Name__c);
    }

    @isTest
    static void update_rejects_deactivating_course_with_enrolled_students() {
        Course__c course = new Course__c(
            Name__c = 'Math 101',
            Course_Name__c = 'Mathematics',
            Code__c = 'M101',
            Max_Capacity__c = 30,
            Is_Active__c = true
        );
        Student__c student = new Student__c(Name__c = 'First Stu',
                Last_Name__c='LNStore',
                Email__c = 'e'+'First_LNStore@gtest.com',
                GPA__c = 3*0.2 +1);
        insert course;
        insert student;
        Enrollment__c enrollment = new Enrollment__c(
         Course__c = course.Id,
         Student__c = student.Id,
         Status__c = 'Enrolled'       
        );
        insert enrollment;
        try {
            course.Is_Active__c = false;
            update course;
            System.assert(false, 'Should have thrown an exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot deactivate'), 'Error should mention deactivation');
        }
    }

    @isTest
    static void update_allows_deactivating_course_with_no_students() {
        Course__c course = new Course__c(
            Name__c = 'Math 101',
            Course_Name__c = 'Mathematics',
            Code__c = 'M101',
            Max_Capacity__c = 30,
            Is_Active__c = true
        );
        insert course;

        Test.startTest();
        course.Is_Active__c = false;
        update course;
        Test.stopTest();

        Course__c result = [SELECT Is_Active__c FROM Course__c WHERE Id = :course.Id];
        System.assertEquals(false, result.Is_Active__c);
    }

    // bulk insert

    @isTest
    static void bulk_insert_200_courses() {
        List<Course__c> courses = new List<Course__c>();
        for (Integer i = 0; i < 200; i++) {
            courses.add(new Course__c(
                Name__c = 'Course ' + i,
                Course_Name__c = 'Course Name ' + i,
                Code__c = 'C' + i,
                Max_Capacity__c = 20
            ));
        }

        Test.startTest();
        insert courses;
        Test.stopTest();

        System.assertEquals(200, [SELECT COUNT() FROM Course__c], 'Expected 200 courses');
    }
}