public with sharing class StudentService {

    public class StudentException extends Exception{
    }
    private static final Decimal GPA_MIN = 0;
    private static final Decimal GPA_MAX = 4;


    public static void validateStudent(List<Student__c> students) {

        if(students == null || students.isEmpty()) return;

        for (Student__c S:students){
            if (String.isBlank(S.Email__c)) {
                throw new StudentException('Email is required');
            }

            if (S.GPA__c != null && (S.GPA__c < GPA_MIN ||S.GPA__c > GPA_MAX)) {
                throw new StudentException('GPA must be between 0 and 4');
            }

            if(String.isBlank(S.Name__c) || String.isBlank(S.Last_Name__c)){
                throw new StudentException('First Name and Last Name required');
            }
        }
    }
    

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents(Integer recordLimit) {
        Integer safeLimit = (recordLimit == null || recordLimit <= 0)
        ? 50 : Math.min(recordLimit,2000);
        return [
            SELECT Id, Name__c,Last_Name__c, Email__c, GPA__c, Status__c
            FROM Student__c with USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT :safeLimit];
    }

  
//    public static string methodName(){
//     try {
        
//     } catch (Exception e) {
//         throw new AuraHandledException(e.getMessage());
//     }
//    }

    @AuraEnabled
    public static Id createStudent(Student__c s){
        try {
            validateStudent(new List<Student__c> { s });
            insert as user s;
            return s.Id;
            
        } catch (StudentException e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        } catch (DmlException e){
            System.debug(LoggingLevel.Error,'createStudent - DML failed with error: '+e.getMessage());
            AuraHandledException ex = new AuraHandledException('Could not save student. Please try again.');
            ex.setMessage('Could not save student. Please retry');
            throw ex;
        }
    }
}