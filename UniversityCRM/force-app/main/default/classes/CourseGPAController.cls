public with sharing class CourseGPAController {
    public class CourseGPAControllerException extends Exception {}

    public class CourseGPAData {
        @AuraEnabled public String courseName;
        @AuraEnabled public Decimal avgGrade;
    }

    @AuraEnabled(cacheable=true)
    public static List<CourseGPAData> getCourseAverageGrades() {
        try {
            List<AggregateResult> results = [
                SELECT Course__r.Name__c courseName,
                       AVG(Grade__c) avgGrade
                FROM Enrollment__c
                WHERE Status__c = 'Enrolled'
                AND Grade__c != null
                WITH USER_MODE
                GROUP BY Course__r.Name__c
            ];

            List<CourseGPAData> data = new List<CourseGPAData>();
            for (AggregateResult ar : results) {
                CourseGPAData row = new CourseGPAData();
                row.courseName = (String) ar.get('courseName');
                row.avgGrade = (Decimal) ar.get('avgGrade');
                data.add(row);
            }
            return data;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}