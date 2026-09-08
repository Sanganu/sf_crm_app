public with sharing class CourseService {
    
    public class CourseException extends Exception{}
    
    public static void validateCourse(List<Course__c> courses) {
        
        if(courses == null || courses.isEmpty()) return;
        for(Course__c c: courses){
            if (String.isBlank(c.Name__c)) {
                throw new CourseException('Name is required');
            }
            
            if (String.isBlank(c.Course_Name__c)) {
                throw new CourseException('Course Name is required');
            }
            
            if (String.isBlank(c.Code__c)) {
                throw new CourseException('Course Code is required');
            }
        }
    }
    
    @AuraEnabled
    public static void createCourse(List<Course__c> c) {
        try{
            validateCourse(c); // validation FIRST
            insert as user c;
        }catch(CourseException e){
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        }catch(DmlException e){
            System.debug(LoggingLevel.ERROR,'Create course DML failure: '+e.getMessage());
            AuraHandledException ex = new AuraHandledException('Unable to save course data. Please try again later');
            ex.setMessage('Unable to save course data. Please try again later');
            throw ex;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getCourses(Integer recordLimit) {
        Integer safeLimit = (recordLimit == null || recordLimit <= 0)
            ? 50 : Math.min(recordLimit, 2000);
        return [
            SELECT Id, Name__c, Course_Name__c, Code__c, Max_Capacity__c, Credits__c, Department__c, Is_Active__c
            FROM Course__c
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT :safeLimit
        ];
    }
    
}