public with sharing class CourseServiceTriggerHandler extends TriggerHandler{
    private List<Course__c> newCourses;
    private List<Course__c> oldCourses;
    private Map<Id, Course__c> newCoursesMap;
    private Map<Id, Course__c> oldCoursesMap;

    public CourseServiceTriggerHandler() {
        this.newCourses    = (List<Course__c>) Trigger.new;
        this.oldCourses    = (List<Course__c>) Trigger.old;
        this.newCoursesMap = (Map<Id, Course__c>) Trigger.newMap;
        this.oldCoursesMap = (Map<Id, Course__c>) Trigger.oldMap;
    }
    
    protected override void beforeInsert(){
        for(Course__c course:newCourses){
            validateRequiredFields(course);
            validateEnrollmentDate(course);
            setDefault(course);
        }
    }
    
    protected override void beforeUpdate(){
        for(Course__c course:newCourses){
            Course__c oldCourse = oldCoursesMap.get(course.Id);
            validateRequiredFields(course);
            validateEnrollmentDate(course);
            preventDeactivatingFullCourse(course,oldCourse);
        }
    }

    //Validate input
    private static void validateRequiredFields(Course__c course){
        if(String.isBlank(course.Name__c)){
            course.Name__c.addError('Course Name__c is required');
        }
        if(String.isBlank(course.Course_Name__c)){
            course.Course_Name__c.addError('Course course name is required');
        }
        if(String.isBlank(course.Code__c)){
            course.Code__c.addError('Course code is required');
        }
    }

    //Enrollment date capacity
    private static void validateEnrollmentDate(Course__c course){
        if(course.Course_End_Date__c != null && course.Course_Start_Date__c != null){
            if(course.Course_End_Date__c <= course.Course_Start_Date__c){
                course.Course_End_Date__c.addError('Course End Date is invalid should be greater than Start Date');
            }
        }
    }

    //Max Capacity 
    private void validateMaxCapacity(Course__c course) {
        if (course.Max_Capacity__c != null && course.Max_Capacity__c < 1) {
            course.Max_Capacity__c.addError('Max Capacity must be at least 1.');
        }
    }

    //Set Defaults
    private void setDefault(Course__c course){
        if(course.Max_Capacity__c == null){
            course.Max_Capacity__c = 25;
        }
        if(course.is_Active__c == null){
            course.is_Active__c = true;
        }
    }

    //Stops changing Active when Students are enrolled
        private void preventDeactivatingFullCourse(Course__c course, Course__c oldCourse) {
        if (oldCourse.Is_Active__c == true 
            && course.Is_Active__c == false
            && course.Total_Students_Enrolled__c > 0) {
            course.Is_Active__c.addError(
                'Cannot deactivate a course with ' 
                + Integer.valueOf(course.Total_Students_Enrolled__c) 
                + ' enrolled student(s). Please un enroll them first.'
            );
        }
    }

    //Capacity
     private void preventCapacityBelowEnrolled(Course__c course) {
        if (course.Max_Capacity__c != null 
            && course.Total_Students_Enrolled__c != null
            && course.Max_Capacity__c < course.Total_Students_Enrolled__c) {
            course.Max_Capacity__c.addError(
                'Max Capacity cannot be less than current enrollment (' 
                + Integer.valueOf(course.Total_Students_Enrolled__c) + ').'
            );
        }
    }
    
}