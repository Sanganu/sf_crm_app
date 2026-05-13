public with sharing class StudentService {

    public static void validateStudent(Student__c s) {

        if (String.isBlank(s.Email__c)) {
            throw new IllegalArgumentException('Email is required');
        }

        if (s.GPA__c < 0 || s.GPA__c > 5) {
            throw new IllegalArgumentException('GPA must be between 0 and 10');
        }
    }

    public static List<Student__c> getStudents() {

        return [
            SELECT Id, Name, Email__c, GPA__c, Status__c
            FROM Student__c
        ];
    }
}