public with sharing class CourseController {
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getCourses() {
        return [
            SELECT Id, Code__c, Course_End_Date__c, Course_External_Id__c, Course_Name__c,
            Credits__c, Department__c, Name, Is_Active__c,Semester__C,
            Max_Capacity__c, Name__c, Total_students_enrolled__c
            FROM Course__c
            ORDER BY Name
            LIMIT 50
        ];
    }
}