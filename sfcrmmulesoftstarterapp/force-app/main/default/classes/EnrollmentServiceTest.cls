public with sharing class EnrollmentService {

    public static void validateEnrollment(Enrollment__c e) {

        if (e.Student__c == null)) {
            throw new IllegalArgumentException('Student is required');
        }

        if (se.Course__c == null) {
            throw new IllegalArgumentException('Course is required');
        }
    }

    public static void enrollStudent(
        Id studentId,
        Id courseId
    ){
        Enrollment__c e = new Enrollment__c();
        e.Student__c = studentId;
        e.Course__c = courseId;
        validateEnrollment(e);
        try{
            insert e;
        }catch (DmlException ex) {

            throw new AuraHandledException(
                'Enrollment failed'
            );
        }
    }
    public static List<Enrollment__c> getEnrollments() {

        return [
            SELECT Id, 
            Student__c,
            Student__r.Name,
            Student__r.Last_Name,
            Course__c,
            Course__r.Name,
            Status__c
            FROM Enrollment__c
        ];
    }
}