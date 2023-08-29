/** 
* 
* Description   : This class is used to test the functionality of ZohoSignService class
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
@isTest
public class ZohoSignServiceTest {

    // Test method for sending a document for sign for a Person Account
    @IsTest
    public static void sendDocumentForSignForPersonAccountTest() {
        
        // Set up mock HTTP callouts
        Test.setMock(HttpCalloutMock.class, new ZohoSignServiceMock()); 
        
        // Create a test Person Account
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.PERSON_ACC_REC_TYPE_NAME).getRecordTypeId();
       
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Account';
        acc.Gender__pc = 'Male';
        acc.Type = 'Partner';
        acc.PersonEmail = 'test@test.com';
        acc.RecordTypeId = recordTypeId;
        insert acc;
        
        // Prepare a list of Account Ids
        List<String> accList = new List<String>();
        accList.add(acc.Id);
        
        Account account = [SELECT Verification_Status__c FROM Account WHERE FirstName = 'Test' AND RecordTypeId =:recordTypeId LIMIT 1];
        account.Verification_Status__c = 'Verified';
        
        // Start test execution
        Test.startTest();
        
        update account;
        //ZohoSignService.sendDocumentForSign(accList);
        Test.stopTest();
        
        // Verify the onboarding status of the Account
        Account accountRecord = [SELECT Onboarding_Status__c,NDA_Document_Id__c,MSA_Document_Id__c FROM Account WHERE FirstName = 'Test' LIMIT 1];
        System.assertEquals('Signature Pending', accountRecord.Onboarding_Status__c);
    }
    
    // Test method for sending a document for sign for a Company Account
    @IsTest
    public static void sendDocumentForSignForCompanyAccountTest() {
        // Set up mock HTTP callouts
        Test.setMock(HttpCalloutMock.class, new ZohoSignServiceMock()); 
        
        // Create a test Company Account
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
        insert acc;
        
        // Create a test Contact associated with the Company Account
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.Gender__c = 'Male';
        con.Title = 'Resource';
        con.AccountId = acc.Id;
        con.Is_Primary_Contact__c = true;
        con.Email = 'test@test.com';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.CON_EXTERNAL_REC_TYPE).getRecordTypeId();
        insert con;
        
        // Prepare a list of Account Ids
        List<String> accList = new List<String>();
        accList.add(acc.Id);
        
        // Start test execution
        Account account = [SELECT Verification_Status__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        account.Verification_Status__c = 'Verified';
        // Start test execution
        Test.startTest();
        update account;
        Test.stopTest();
        
        // Verify the onboarding status of the Account
        Account accountRecord = [SELECT Onboarding_Status__c FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Signature Pending', accountRecord.Onboarding_Status__c);
    }
}