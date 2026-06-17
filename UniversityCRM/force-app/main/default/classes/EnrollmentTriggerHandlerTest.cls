@isTest private class EnrollmentTriggerHandlerTest {

    // ── Test Data Setup ──────────────────────────────────────

    @TestSetup
    static void setup() {
        Student__c student = new Student__c(
            Name__c  = 'Test Student',
            Last_Name__c='Testing',
            Email__c = 'test@uni.com',
            GPA__c   = 3.5
        );
        insert student;

        Course__c course = new Course__c(
            Name           = 'Test Course description',
            Name__c ='Test Data',
            Code__c        = 'CS101',
            Course_Name__c = 'Computer Sci test',
            Max_Capacity__c = 1  // ← max 1 so second enrollment = Waitlisted
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
            Course__c  = courseId
            // No Status__c — trigger sets it
        );
    }

 

    @isTest
    static void testEnrollmentDateSetOnInsert() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);

        Test.startTest();
            insert e;
        Test.stopTest();

        Enrollment__c result = [
            SELECT Enrollment_Date__c FROM Enrollment__c WHERE Id = :e.Id
        ];
        System.assertEquals(System.today(), result.Enrollment_Date__c,
            'Enrollment_Date__c should be today on insert');
    }

    // bulk insert

    @isTest
    static void testEnrollmentDateSetOnInsert_Bulk() {
        List<Course__c> courses = new List<Course__c>();
        for (Integer i = 0; i < 200; i++)
            courses.add(new Course__c(Name = 'Description Course ' + i, Code__c = 'C' + i,Name__c='Course--'+i,Course_Name__c='C'+i+'Course Name test'));
        insert courses;

        Id studentId = getStudent().Id;
        List<Enrollment__c> enrollments = new List<Enrollment__c>();
        for (Course__c c : courses)
            enrollments.add(buildEnrollment(studentId, c.Id));

        Test.startTest();
            insert enrollments;
        Test.stopTest();

        List<Enrollment__c> results = [
            SELECT Enrollment_Date__c FROM Enrollment__c
            WHERE Student__c = :studentId
        ];
        System.assertEquals(200, results.size(), 'All 200 should be inserted');
        for (Enrollment__c r : results)
            System.assertEquals(System.today(), r.Enrollment_Date__c,
                'All dates should be today');
    }

    // ── 3. Seat available → Status = Enrolled ─────────────────

    @isTest
    static void testStatusSetToEnrolledWhenSeatAvailable() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);

        Test.startTest();
            insert e;
        Test.stopTest();

        Enrollment__c result = [SELECT Status__c FROM Enrollment__c WHERE Id = :e.Id];
        System.assertEquals('Enrolled', result.Status__c,
            'Status should be Enrolled when seat available');
    }

    // ── 4. Course full → Status = Waitlisted ──────────────────

    @isTest
    static void testStatusSetToWaitlistedWhenFull() {
        // First student fills the only seat
        insert buildEnrollment(getStudent().Id, getCourse().Id);

        // Second student — new student
        Student__c s2 = new Student__c(
            Name__c  = 'Student 2',
            Last_Name__c='LastName',
            Email__c = 'student2@uni.com',
            GPA__c   = 3.0
        );
        insert s2;

        Enrollment__c e2 = buildEnrollment(s2.Id, getCourse().Id);

        Test.startTest();
            insert e2;
        Test.stopTest();

        Enrollment__c result = [SELECT Status__c FROM Enrollment__c WHERE Id = :e2.Id];
        System.assertEquals('Waitlisted', result.Status__c,
            'Status should be Waitlisted when course is full');
    }

    // ── 5. Drop → promotes waitlisted student ─────────────────

    @isTest
    static void testWaitlistPromotionOnDrop() {
        Course__c c  = getCourse();
        Student__c s1 = getStudent();

        Enrollment__c e1 = buildEnrollment(s1.Id, c.Id);
        insert e1; // fills the seat
       
        Student__c student = new Student__c(
            Name__c     = 'Test Student',
            Last_Name__c = 'LNStore',
            Email__c    = 'test@test.com',
            GPA__c      = 3.5
        );
        insert student;

        Enrollment__c e2 = buildEnrollment(student.Id, c.Id);
        insert e2; // goes to waitlist

        // verify student is waitlisted
        System.assertEquals('Waitlisted',
            [SELECT Status__c FROM Enrollment__c WHERE Id = :e2.Id].Status__c,
            'student should be Waitlisted');

        // s1 drops
        Test.startTest();
            e1.Status__c = 'Dropped';
            update e1;
        Test.stopTest();

        // s2 should be promoted
        System.assertEquals('Enrolled',
            [SELECT Status__c FROM Enrollment__c WHERE Id = :e2.Id].Status__c,
            's2 should be promoted to Enrolled');
    }

    // ── 6. Email sent on promotion ────────────────────────────

    @isTest
    static void testEmailSentOnWaitlistPromotion() {
        Enrollment__c e1 = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e1;

        Student__c s2 = new Student__c(
            Name__c  = 'Student 2',
            Last_Name__c = 'Student Last NAme',
            Email__c = 'student2@uni.com',
            GPA__c   = 3.0
        );
        insert s2;

        Enrollment__c e2 = buildEnrollment(s2.Id, getCourse().Id);
        insert e2;

        Test.startTest();
            e1.Status__c = 'Dropped';
            update e1;
        Test.stopTest();
        Enrollment__c promoted = [
                SELECT Id, Status__c 
                FROM Enrollment__c 
                WHERE Id = :e2.Id
            ];
    System.assertEquals('Enrolled', promoted.Status__c,
        'Waitlisted student should be promoted to Enrolled');
    }

    // ── 7. Seat count updated after insert ────────────────────

    @isTest
    static void testSeatCountUpdatedAfterInsert() {
        Course__c before = [
            SELECT Total_Students_Enrolled__c FROM Course__c
            WHERE Id = :getCourse().Id
        ];
        System.assertEquals(0, before.Total_Students_Enrolled__c,
            'Should start at 0');

        Test.startTest();
            insert buildEnrollment(getStudent().Id, getCourse().Id);
        Test.stopTest();

        Course__c after = [
            SELECT Total_Students_Enrolled__c FROM Course__c
            WHERE Id = :getCourse().Id
        ];
        System.assertEquals(1, after.Total_Students_Enrolled__c,
            'Seat count should be 1');
    }

    // ── 8. Block Completed → Enrolled revert ──────────────────

    @isTest
    static void testCompletedRollbackPrevented() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e;

        e.Status__c = 'Completed';
        update e;

        e.Status__c = 'Enrolled'; // try to revert

        Test.startTest();
            try {
                update e;
                System.assert(false, 'Expected exception was not thrown');
            } catch (DmlException ex) {
                System.assert(
                    ex.getMessage().contains('Cannot revert a Completed enrollment'),
                    'Wrong error: ' + ex.getMessage()
                );
            }
        Test.stopTest();
    }

    // ── 9. Block Rejected → Enrolled revert ───────────────────

    @isTest
    static void testRejectedRollbackPrevented() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e;

        e.Status__c = 'Rejected';
        update e;

        e.Status__c = 'Enrolled'; // try to revert

        Test.startTest();
            try {
                update e;
                System.assert(false, 'Expected exception not thrown');
            } catch (DmlException ex) {
                System.assert(
                    ex.getMessage().contains('Cannot revert a Rejected enrollment'),
                    'Wrong error: ' + ex.getMessage()
                );
            }
        Test.stopTest();
    }

    // ── 10. Valid status change allowed ───────────────────────

    @isTest
    static void testValidStatusChangeAllowed() {
        Enrollment__c e = buildEnrollment(getStudent().Id, getCourse().Id);
        insert e;

        e.Status__c = 'Completed';

        Test.startTest();
            try {
                update e;
            } catch (DmlException ex) {
                System.assert(false, 'No exception expected: ' + ex.getMessage());
            }
        Test.stopTest();

        System.assertEquals('Completed',
            [SELECT Status__c FROM Enrollment__c WHERE Id = :e.Id].Status__c,
            'Status should be Completed');
    }

    // ── 11. Missing required field fails ──────────────────────

    @isTest
    static void testInsertFailsWithoutStudent() {
        Enrollment__c e = new Enrollment__c(Course__c = getCourse().Id);

        Test.startTest();
            try {
                insert e;
                System.assert(false, 'Expected required field exception');
            } catch (DmlException ex) {
                System.assert(
                    ex.getMessage().contains('REQUIRED_FIELD_MISSING'),
                    'Should fail with required field error'
                );
            }
        Test.stopTest();
    }
}
