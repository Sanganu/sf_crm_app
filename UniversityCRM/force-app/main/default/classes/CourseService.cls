public with sharing class CourseService {

    public static void validateCourse(Course__c c) {

        if (String.isBlank(c.Name)) {
            throw new IllegalArgumentException('Course Name is required');
        }

        if (String.isBlank(c.Code__c)) {
            throw new IllegalArgumentException('Course Code is required');
        }
    }

    public static void createCourse(Course__c c) {

        validateCourse(c); // validation FIRST

        insert c;
    }
}