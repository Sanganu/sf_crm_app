public with sharing class StudentTriggerHandler extends TriggerHandler{
    private List<Student__c> newList = (List<Student__c>) Trigger.new;
    protected override void beforeInsert() { applyStatusFromGpa(newList);}
    protected override void beforeUpdate() { applyStatusFromGpa(newList);}  
    private static final Decimal GPS_MIN = 2.3;

    @TestVisible
    private static void applyStatusFromGpa(List<Student__c> students){
        if (students == null) return;
        for(Student__c s:students){
            if(s.GPA__c != null && s.GPA__c > GPS_MIN){
                s.Status__c = 'Active';
            }else{
                s.Status__c = 'New';
            }
        }
    }
}