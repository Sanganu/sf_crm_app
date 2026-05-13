@isTest
private class HelloCRMTest {

    @isTest
    static void testGreet() {

        Test.startTest();

        String result = HelloCRM.greet();

        Test.stopTest();

        System.assertEquals('Hello Salesforce CRM', result);
    }
}