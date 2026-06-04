public with sharing class StudentTriggerHandler extends TriggerHandler{
    private static final Decimal GPA_MIN = 2.3;

    protected override void beforeInsert() {
         applyStatusFromGpa((List<Student__c>) Trigger.new);} 
         
    protected override void beforeUpdate(){
        applyStatusFromGpa((List<Student__C>) Trigger.new);
    }

    @TestVisible
    private static void applyStatusFromGpa(List<Student__c> students){
        if (students == null) return;
        for(Student__c s:students){
            if(s.GPA__c != null && s.GPA__c > GPA_MIN){
                s.Status__c = 'Active';
            }else{
                s.Status__c = 'New';
            }
        }
    }
}