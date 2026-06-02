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

    public static void createCourse(List<Course__c> c) {

        validateCourse(c); // validation FIRST

        insert c;
    }
}
