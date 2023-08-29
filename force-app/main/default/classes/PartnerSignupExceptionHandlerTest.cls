/** 
* 
* Description   : This class is a test class of PartnerSignupExceptionHandler class.
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
@isTest
public class PartnerSignupExceptionHandlerTest {

    @isTest
    static void testLogException_Success() {
        // Test data
        String details = 'Sample exception details';
        Integer lineNumber = 42;
        String methodName = 'testMethod';
        String className = 'TestClass';
        
        // Ensure no exceptions are thrown during insertion
        Test.startTest();
        PartnerSignupExceptionHandler.logException(details, lineNumber, methodName, className);
        Test.stopTest();
        
        // Verify the inserted record
        List<Partner_Onboarding_Exception__c> insertedRecords = [SELECT Id, Exception_Details__c, Line_Number__c, Method_Name__c, Class_Name__c FROM Partner_Onboarding_Exception__c];
        System.assertEquals(1, insertedRecords.size());
        
        Partner_Onboarding_Exception__c insertedRecord = insertedRecords[0];
        System.assertEquals(details, insertedRecord.Exception_Details__c);
        System.assertEquals(lineNumber, insertedRecord.Line_Number__c);
        System.assertEquals(methodName, insertedRecord.Method_Name__c);
        System.assertEquals(className, insertedRecord.Class_Name__c);
    }
}