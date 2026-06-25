public with sharing class StudentController {
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {
        return [
            SELECT Id, Name, Email__c, GPA__c, Status__c
            FROM Student__c
            ORDER BY Name
            LIMIT 50
        ];
    }
}