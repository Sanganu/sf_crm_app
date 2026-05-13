public with sharing class CourseService {

    public static void validateCourse(Course__c c) {

        if (String.isBlank(c.Name)) {
            throw new IllegalArgumentException('Course Name is required');
        }

        if (String.isBlank(c.Code__c)) {
            throw new IllegalArgumentException('Course Code is required');
        }
    }

    public static List<Course__c> getCourses() {

        return [
            SELECT Id, Name, Code__c
            FROM Course__c
        ];
    }

    public static void createCourse(Course__c c) {

        validateCourse(c);

        try {

            insert c;

        } catch (DmlException ex) {

            throw new AuraHandledException(
                'Unable to create course'
            );
        }
    }
}