trigger Tri_Student_GPA on Student__c (before insert, before update) {
   new StudentTriggerHandler().run();
}