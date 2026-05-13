public with sharing class EnrollmentService {

    public static void validateEnrollment(
        Enrollment__c e
    ) {

        if (e.Student__c == null) {
            throw new IllegalArgumentException(
                'Student is required'
            );
        }

        if (e.Course__c == null) {
            throw new IllegalArgumentException(
                'Course is required'
            );
        }
    }

    public static void enrollStudent(
        Id studentId,
        Id courseId
    ) {

        Enrollment__c e = new Enrollment__c();

        e.Student__c = studentId;
        e.Course__c = courseId;
        e.Status__c = 'Enrolled';

        validateEnrollment(e);

        insert e;
    }
}