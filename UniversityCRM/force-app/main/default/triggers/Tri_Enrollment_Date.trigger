trigger Tri_Enrollment_Date on Enrollment__c (before insert) {
  for(Enrollment__c e: Trigger.new){
      e.Enrollment_Date__c = System.today();
  }
}