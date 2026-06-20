public class GradeCalculatorService{
    public class Request{
        @InvocableVariable(required = true)
        public Decimal grade;
        @InvocableVariable(required = true)
        public Id enrollmentId;
    }
     public class Response{
        @InvocableVariable
        public String letterGrade;
        @InvocableVariable
        public Id enrollmentId;
    }
    @InvocableMethod(
        label='Calculate Letter Grade'
        description='Converts numeric grade to letter grade'
        category='Enrollment'
    )
    public static List<Response> calculateLetterGrade(List<Request> requests){
        List<Response> responses = new Response();
        for (Request req : requests){
            Response res = new Response();
            res.enrollmentId = req.enrollmentId;
            res.letterGrade = req.grade >= 90 ? 'A'
            : req.grade >= 80 ? 'B'
            : req.grade >= 70 ? 'C' : 'F';
            responses.add(res)
        } 
        return responses;  
    }
}