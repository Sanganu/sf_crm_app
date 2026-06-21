@isTest
private class GradeCalculatorServiceTest {

    @TestSetup
    static void makeData() {}

    @isTest
    static void testGradeA() {
        GradeCalculatorService.Request req = new GradeCalculatorService.Request();
        req.grade = 92;
        Test.startTest();
        List<GradeCalculatorService.Response> results = GradeCalculatorService.calculateLetterGrade(
            new List<GradeCalculatorService.Request>{ req }
        );
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Should return one response');
        System.assertEquals('A', results[0].letterGrade, 'Grade 92 should be A');
    }

    @isTest
    static void testGradeF() {
        GradeCalculatorService.Request req = new GradeCalculatorService.Request();
        req.grade = 45;
        Test.startTest();
        List<GradeCalculatorService.Response> results = GradeCalculatorService.calculateLetterGrade(
            new List<GradeCalculatorService.Request>{ req }
        );
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Should return one response');
        System.assertEquals('F', results[0].letterGrade, 'Grade 45 should be F');
    }

    @isTest
    static void testNullGrade() {
        GradeCalculatorService.Request req = new GradeCalculatorService.Request();
        req.grade = null;
        Test.startTest();
        List<GradeCalculatorService.Response> results = GradeCalculatorService.calculateLetterGrade(
            new List<GradeCalculatorService.Request>{ req }
        );
        Test.stopTest();
        System.assertEquals(null, results[0].letterGrade, 'Null grade should return null letter');
    }

    @isTest
    static void testBulkRequest() {
        List<GradeCalculatorService.Request> request = new List<GradeCalculatorService.Request>();
        Decimal[] grades = new Decimal[]{ 92, 54, 67, 46, 80, 76, 89 };
        for (Decimal g : grades) {
            GradeCalculatorService.Request req = new GradeCalculatorService.Request();
            req.grade = g;
            request.add(req);
        }
        Test.startTest();
        List<GradeCalculatorService.Response> results = GradeCalculatorService.calculateLetterGrade(
            request // Fix 4: was `{req}` (out of scope); should be the built list
        );
        Test.stopTest();
        System.assertEquals(7, results.size(), 'Should return seven letter grades in response');
        System.assertEquals('A', results[0].letterGrade, 'Grade 92 should be A');
        System.assertEquals('B', results[6].letterGrade, 'Grade 89 should be B');
    }
}