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
    
    public static String partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
    public static String individualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.PERSON_ACC_REC_TYPE_NAME).getRecordTypeId();
    
    //This method is used to prepare test data
    @testSetup
    static void setup() {
        
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Partner_Onboarding' LIMIT 1];

        PermissionSetAssignment assignmentRecord;
        List<PermissionSetAssignment> assignmentRecords = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :currentUser.Id AND PermissionSetId = :permissionSet.Id LIMIT 1];
        
        if (assignmentRecords.size() > 0) {
            assignmentRecord = assignmentRecords[0];
        } else {
            PermissionSetAssignment perSetAssign = new PermissionSetAssignment();
            perSetAssign.AssigneeId = currentUser.Id;
            perSetAssign.PermissionSetId = permissionSet.Id;
            insert perSetAssign;
            assignmentRecord = perSetAssign; // Assign the newly inserted record to assignmentRecord
        }
        
        // Create a test Person Account
        Account personAccount = new Account();
        personAccount.FirstName = 'Test';
        personAccount.LastName = 'Account';
        personAccount.Gender__pc = 'Male';
        personAccount.Type = 'Partner';
        personAccount.PersonEmail = 'test@test.com';
        personAccount.RecordTypeId = individualRecordTypeId;
        insert personAccount;
        
        // Create a test Company Account
        Account companyAccount = new Account();
        companyAccount.Name = 'Test Company';
        companyAccount.RecordTypeId = partnerRecordTypeId;
        insert companyAccount;
        
        // Create a test Contact associated with the Company Account
        Contact contact = new Contact();
        contact.LastName = 'Test Contact';
        contact.Gender__c = 'Male';
        contact.Title = 'Resource';
        contact.AccountId = companyAccount.Id;
        contact.Is_Primary_Contact__c = true;
        contact.Email = 'test@test.com';
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.CON_EXTERNAL_REC_TYPE).getRecordTypeId();
        insert contact;
    }

    // Test method for sending a document for sign for a Person Account
    @IsTest
    public static void sendDocumentForSignForPersonAccountTest() {
        
        // Set up mock HTTP callouts
        Test.setMock(HttpCalloutMock.class, new ZohoSignServiceMock()); 
        
        Account account = [SELECT Verification_Status__c FROM Account WHERE FirstName = 'Test' AND RecordTypeId =:individualRecordTypeId LIMIT 1];
        account.Verification_Status__c = 'Verified';
        
        // Start test execution
        Test.startTest();
        
        update account;
        //ZohoSignService.sendDocumentForSign(accList);
        Test.stopTest();
        
        // Verify the onboarding status of the Account
        Account accountRecord = [SELECT Onboarding_Status__c FROM Account WHERE FirstName = 'Test' LIMIT 1];
        System.assertEquals('Signature Pending', accountRecord.Onboarding_Status__c);
    }
    
    // Test method for sending a document for sign for a Company Account
    @IsTest
    public static void sendDocumentForSignForCompanyAccountTest() {
        // Set up mock HTTP callouts
        Test.setMock(HttpCalloutMock.class, new ZohoSignServiceMock()); 
        
        Account account = [SELECT Verification_Status__c FROM Account WHERE Name = 'Test Company' AND RecordTypeId=:partnerRecordTypeId LIMIT 1];
        account.Verification_Status__c = 'Verified';
        // Start test execution
        Test.startTest();
        update account;
        Test.stopTest();
        
        // Verify the onboarding status of the Account
        Account accountRecord = [SELECT Onboarding_Status__c FROM Account WHERE Name = 'Test Company' LIMIT 1];
        System.assertEquals('Signature Pending', accountRecord.Onboarding_Status__c);
    }
}