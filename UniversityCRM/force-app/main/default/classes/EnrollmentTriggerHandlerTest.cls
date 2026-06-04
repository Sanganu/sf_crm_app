@isTest
private class EnrollmentTriggerHandlerTest {

    // ── Test Data Setup ──────────────────────────────────────

    @TestSetup
    static void setup() {
        Student__c student = new Student__c(
            Name__c  = 'Test Student',
            Email__c = 'test@uni.com',
            GPA__c   = 3.5
        );
        insert student;

        Course__c course = new Course__c(
            Name   = 'Test Course',
            Code__c = 'CS101'
        );
        insert course;
    }

    // ── Helpers ───────────────────────────────────────────────

    private static Student__c getStudent() {
        return [SELECT Id FROM Student__c LIMIT 1];
    }

    private static Course__c getCourse() {
        return [SELECT Id FROM Course__c LIMIT 1];
    }

    private static Enrollment__c buildEnrollment(Id studentId, Id courseId) {
        return new Enrollment__c(
            Student__c = studentId,
            Course__c  = courseId,
            Status__c  = 'Active'
        );
    }

    // ── Test: beforeInsert — Enrollment date auto-set ─────────

    @isTest
    static void testEnrollmentDateSetOnInsert() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);

        System.Test.startTest();
            insert e;
        System.Test.stopTest();

        Enrollment__c result = [
            SELECT Enrollment_Date__c
            FROM   Enrollment__c
            WHERE  Id = :e.Id
        ];

        System.assertEquals(
            System.today(),
            result.Enrollment_Date__c,
            'Enrollment_Date__c should be set to today on insert'
        );
    }

    // ── Test: beforeInsert — Bulk (200 records) ───────────────

    @isTest
    static void testEnrollmentDateSetOnInsert_Bulk() {
        // Need 200 unique courses for 200 enrollments
        List<Course__c> courses = new List<Course__c>();
        for (Integer i = 0; i < 200; i++)
            courses.add(new Course__c(Name = 'Course ' + i, Code__c = 'C' + i));
        insert courses;

        Id studentId = getStudent().Id;
        List<Enrollment__c> enrollments = new List<Enrollment__c>();
         
        for (Course__c c : courses)
            enrollments.add(buildEnrollment(studentId, c.Id));

        System.Test.startTest();
            insert enrollments;
        System.Test.stopTest();

        List<Enrollment__c> results = [
            SELECT Enrollment_Date__c FROM Enrollment__c
            WHERE  Student__c = :studentId
        ];

        System.assertEquals(200, results.size(), 'All 200 should be inserted');
        for (Enrollment__c r : results)
            System.assertEquals(System.today(), r.Enrollment_Date__c,
                'All 200 enrollment dates should be today');
    }

    // ── Test: beforeUpdate — block Completed → Active rollback ─

    @isTest
    static void testStatusRollbackPrevented() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e;

        // Move to Completed (valid)
        e.Status__c = 'Completed';
        update e;

        // Try to revert back to Active (should fail)
        e.Status__c = 'Active';

        System.Test.startTest();
            try {
                update e;
                System.assert(false, 'Expected exception was not thrown');
            } catch (DmlException ex) {
                System.assert(
                    ex.getMessage().contains('Cannot revert a Completed enrollment'),
                    'Wrong error message: ' + ex.getMessage()
                );
            }
        System.Test.stopTest();
    }

    // ── Test: beforeUpdate — valid status change allowed ───────

    @isTest
    static void testValidStatusChangeAllowed() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e;

        // Active → Completed is valid
        e.Status__c = 'Completed';

        System.Test.startTest();
            try {
                update e; 
            } catch (DmlException ex) {
                System.assert(false, 'No exception expected: ' + ex.getMessage());
            }
        System.Test.stopTest();

        Enrollment__c result = [SELECT Status__c FROM Enrollment__c WHERE Id = :e.Id];
        System.assertEquals('Completed', result.Status__c, 'Status should be Completed');
    }

    // ── Test: afterInsert — course seat count updated ──────────

    @isTest
    static void testSeatCountUpdatedAfterInsert() {
        Course__c course = getCourse();

        // Verify initial seat count
        Course__c before = [SELECT Total_students_enrolled__c FROM Course__c WHERE Id = :course.Id];
        System.assertEquals(0, before.Total_students_enrolled__c, 'Should start at 0');

        Enrollment__c e = buildEnrollment(getStudent().Id, course.Id);

        System.Test.startTest();
            insert e;
        System.Test.stopTest();

        Course__c after = [SELECT Total_students_enrolled__c FROM Course__c WHERE Id = :course.Id];
        System.assertEquals(1, after.Total_students_enrolled__c, 'Seat count should be 1 after enrollment');
    }

    // ── Test: negative — missing required field ────────────────

    @isTest
    static void testInsertFailsWithoutStudent() {
        Enrollment__c e = new Enrollment__c(
            Course__c = getCourse().Id
            // Student__c deliberately omitted
        );

        System.Test.startTest();
            try {
                insert e;
                System.assert(false, 'Expected required field exception');
            } catch (DmlException ex) {
                System.assert(
                    ex.getMessage().contains('REQUIRED_FIELD_MISSING'),
                    'Should fail with required field error'
                );
            }
        System.Test.stopTest();
    }
}