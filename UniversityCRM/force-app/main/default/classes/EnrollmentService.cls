public with sharing class EnrollmentService {

    public class EnrollmentException extends Exception {}

    public static void validateEnrollments(List<Enrollment__c> enrollments) {
        for (Enrollment__c e : enrollments) {
            if (e.Student__c == null) throw new EnrollmentException('Student is required');
            if (e.Course__c  == null) throw new EnrollmentException('Course is required');
        }
    }

    //Duplicates (Set is used)
    private static void rejectDuplicates(List<Enrollment__c> incoming) {
        Set<Id> studentIds = new Set<Id>();
        Set<Id> courseIds  = new Set<Id>();
        for (Enrollment__c e : incoming) {
            studentIds.add(e.Student__c);
            courseIds.add(e.Course__c);
        }
        Map<String, Enrollment__c> existing = new Map<String, Enrollment__c>();
        for (Enrollment__c e : [
            SELECT Id, Student__c, Course__c
            FROM Enrollment__c
            WHERE Student__c IN :studentIds AND Course__c IN :courseIds
            WITH USER_MODE
        ]) {
            existing.put(e.Student__c + '|' + e.Course__c, e);
        }
        for (Enrollment__c e : incoming) {
            if (existing.containsKey(e.Student__c + '|' + e.Course__c)) {
                throw new EnrollmentException('Student already enrolled in this course');
            }
        }
    }

    @AuraEnabled
    public static List<Id> enrollStudents(List<Id> studentIds, Id courseId) {
        if (studentIds == null || studentIds.isEmpty() || courseId == null) {
            throw new EnrollmentException('studentIds and courseId are required');
        }
        List<Enrollment__c> toInsert = new List<Enrollment__c>();
        for (Id sid : studentIds) {
            toInsert.add(new Enrollment__c(
                Student__c = sid,
                Course__c  = courseId,
                Status__c  = 'Enrolled'
            ));
        }
        validateEnrollments(toInsert);
        rejectDuplicates(toInsert);
        insert as user toInsert;
        return new List<Id>(new Map<Id, Enrollment__c>(toInsert).keySet());
    }

    @AuraEnabled(cacheable=true)
    public static List<Enrollment__c> getEnrollments() {
        return [
            SELECT Id, Status__c,
                   Student__c, Student__r.Name, Student__r.Name__c, Student__r.Last_Name__c,
                   Course__c,  Course__r.Name,  Course__r.Code__c
            FROM Enrollment__c
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }
}
"