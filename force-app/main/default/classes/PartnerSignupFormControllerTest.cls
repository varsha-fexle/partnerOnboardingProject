/** 
* 
* Description   : This class is a test class of PartnerSignupFormController class.
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 21 March 2023
* 
**/
@isTest
public class PartnerSignupFormControllerTest {
    
    //This method contains test data
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
        
        Account acc = new Account(Name = 'Test Account', Website = 'test.com');
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
        insert acc;
        
        Account acc1 = new Account(Name = 'Test Account One', Website = 'testnew.com');
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
        insert acc1;
        
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.Email = 'test@example.com';
        contact.AccountId = acc.Id;
        contact.Title = 'Resource';
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.CON_EXTERNAL_REC_TYPE).getRecordTypeId();
        insert contact;
    }
    
    //This method is used to fetch account
    @isTest
    public static void testGetAccount() {
        
         List<Account> accList = [SELECT Name, Website FROM Account WHERE Name =:'Test Account'];
          
         Test.startTest();
         String result = PartnerSignupFormController.getAccount(accList[0].Name, accList[0].Website);
         Test.stopTest();
        
         Account account = [SELECT Id, Name, Website From Account Where Id =:result LIMIT 1];
        
         System.assertEquals('Test Account', account.Name);
         System.assertEquals('test.com', account.Website);
     
    } 
    
    //This method is used to fetch account when account is not present
    @isTest
    public static void testGetAccountWhenAccountIsNotFound() {
          
         Test.startTest();
         String result = PartnerSignupFormController.getAccount('Testing Account', 'abc.com');
         Test.stopTest();
        
         System.assertEquals(PartnerSignupFormConstants.COMPANY_NOT_FOUND, result);
     
    }

    //This method is used to create contact
    @isTest
    public static void testCreateContact() {
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        String contactInfoJsonString = '{"firstName":"Test","lastName":"Resource","email":"test@contact.com","mobileNumber":"6756676765","aadharCard":"5433 3421 4532","panCardNumber":"VQWER4564Q","isPrimaryContact":true,"accountId":"'+acc.Id+'"}';
        Test.startTest();
        String result = PartnerSignupFormController.createContact(contactInfoJsonString);
        Test.stopTest();
        
        List<Contact> conList = [SELECT Id, FirstName, LastName From Contact Where Id =:result];
        
        System.assertEquals('Test', conList[0].FirstName);
        System.assertEquals('Resource', conList[0].LastName);
    }
    
    //This method is used to create contact with null JSON
    @isTest
    public static void testcreateContactWithNullArgument() {
        
        Test.startTest();
        String result = PartnerSignupFormController.createContact(null);
        Test.stopTest();
        
        System.assertEquals(PartnerSignupFormConstants.CONTACT_CREATION_ERROR, result);
    }
    
    //This method is used to create contact with invalid JSON
    @isTest
    public static void testcreateContactWithException() {
        
        // Prepare the test data, including the JSON input that will cause an exception.
        String invalidJSON = 'Invalid JSON Data';

        Test.startTest();
        String result = PartnerSignupFormController.createContact(invalidJSON);
        Test.stopTest();

        // Replace these assertions with the specific behavior you expect in the catch block.
        System.assertEquals(PartnerSignupFormConstants.CONTACT_CREATION_ERROR, result);
    }

    //This method is used to create person account
    @isTest
    public static void testCreatePersonAccount() {
        
        String accountInfoJsonString = '{"firstName":"Test","lastName":"Account","email":"test@account.com","mobileNumber":"9887675654","aadharCard":"6565 5432 1234","panCardNumber":"VGWQA6766X","accountBillingStreet":"street","accountBillingCity":"city","accountBillingState":"state","accountBillingPostalCode":"55566677","accountBillingCountry":"India","accountHolderName":"account name","bankName":"bank name","brachAddress":"branch ","accountNumber":"67676767","ifscCode":"67675667"}';
        
        Test.startTest();
        String result = PartnerSignupFormController.createPersonAccount(accountInfoJsonString);
        Test.stopTest();
        
        List<Account> accList = [SELECT Id, FirstName, LastName From Account Where Id =:result];
        
        System.assertEquals('Test', accList[0].FirstName);
        System.assertEquals('Account', accList[0].LastName);
    } 
    
    //This method is used to create person account with invalid JSON
    @isTest
    static void testCreatePersonAccountWithException() {
        
        // Prepare the test data, including the JSON input that will cause an exception.
        String invalidJSON = 'Invalid JSON Data';

        Test.startTest();
        String result = PartnerSignupFormController.createPersonAccount(invalidJSON);
        Test.stopTest();

        // Replace these assertions with the specific behavior you expect in the catch block.
        System.assertEquals('Error in creating company', result);
    }
    
    //This method is used to create person account with null JSON
    @isTest
	public static void testCreatePersonAccountWithNullArgument() {
      
        Test.startTest();
        String result = PartnerSignupFormController.createPersonAccount(null);
        Test.stopTest();
        
        System.assertEquals('Error in creating company', result);
    }

    //This method is used to create account
    @isTest
    public static void testCreateCompanyAccount() {
        
        String accountInfoJsonString = '{"accountName":"Test Company","website":"testcomp.com","gstNumber":"09WADKF6173H1ZG","companyPANNumber":"QWXWQ6767G","accountBillingStreet":"street","accountBillingCity":"city","accountBillingState":"state","accountBillingPostalCode":"676765","accountBillingCountry":"country","accountHolderName":"Account Name","bankName":"Bank Name","brachAddress":"Branch","accountNumber":"787867","ifscCode":"676767"}';
        
        Test.startTest();
        String result = PartnerSignupFormController.createCompanyAccount(accountInfoJsonString);
        Test.stopTest();
        
        List<Account> accList = [SELECT Id, Name, Website From Account Where Id =:result];
        
        System.assertEquals('Test Company', accList[0].Name);
        System.assertEquals('testcomp.com', accList[0].Website);
    }
    
    //This method is used to create account with null JSON
    @isTest
    public static void testCreateCompanyAccountWithNullArgument() {
		
        Test.startTest();
        String result = PartnerSignupFormController.createCompanyAccount(null);
        Test.stopTest();
        
        System.assertEquals('Error in creating company', result);
    }
    
    //This method is used to create account with invalid JSON
    @isTest
    public static void testCreateCompanyAccountWithException() {
		
       // Prepare the test data, including the JSON input that will cause an exception.
       String invalidJSON = 'Invalid JSON Data';

       Test.startTest();
       String result = PartnerSignupFormController.createCompanyAccount(invalidJSON);
       Test.stopTest();

       // Add assertions to verify that the catch block is handling the exception.
       System.assertEquals('Error in creating company', result);
    }
    
    //This method is used to fetch contact
    @IsTest
    public static void testFetchContact() {
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        String result = PartnerSignupFormController.fetchContact('test@example.com', acc.Id);
        Test.stopTest();
        
        System.assertEquals('Found', result);
    }
    
    //This method is used to fetch contact when contact is not present
    @IsTest
    public static void testFetchContactWhenContactIsNotFound() {
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account One' LIMIT 1];

        Test.startTest();
        String result = PartnerSignupFormController.fetchContact('test@example.com', acc.Id);
        Test.stopTest();
        
        System.assertEquals('Not Found', result);
    }
    
    //This method is used to upload file in account when file title is gstPdf
    @isTest
    static void testUploadFileOnAccountWithGstFile() {
        
        Account  acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String testFileName = 'test.pdf';
        String testBase64Data = 'JVBERi0xLjYNJeLjz9MNCjEwNTkgMCBvYmoNPDwvTGluZWFyaXplZCAxL0wgMjExMjM5L08gMTA2Mi9FIDE3MTE4Ni9OIDUvVCAyMTA4MDkvSCBbIDUyNCAyOTNdPj4NZW5kb2JqDSAgICAgICAgICAgDQoxMDgyIDAgb2JqDTw8L0RlY29kZVBhcm1zPDwvQ29sdW1ucyA1L1ByZWRpY3RvciAxMj4';
        String testFileTitle = PartnerSignupFormConstants.GST;

        Test.startTest();
        String result = PartnerSignupFormController.uploadFileOnAccount(acc.Id, testFileName, testBase64Data, testFileTitle);
        Test.stopTest();

        System.assertEquals(PartnerSignupFormConstants.SUCCESS_MESSAGE, result);
        System.assertNotEquals(PartnerSignupFormConstants.FAILED_MESSAGE,result);
    }
    
    //This method is used to upload file in account when file title is panPdf
    @isTest
    static void testUploadFileOnAccountWithPanFile() {
        
        Account  acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String testFileName = 'test.pdf';
        String testBase64Data = 'JVBERi0xLjYNJeLjz9MNCjEwNTkgMCBvYmoNPDwvTGluZWFyaXplZCAxL0wgMjExMjM5L08gMTA2Mi9FIDE3MTE4Ni9OIDUvVCAyMTA4MDkvSCBbIDUyNCAyOTNdPj4NZW5kb2JqDSAgICAgICAgICAgDQoxMDgyIDAgb2JqDTw8L0RlY29kZVBhcm1zPDwvQ29sdW1ucyA1L1ByZWRpY3RvciAxMj4';
        String testFileTitle = PartnerSignupFormConstants.PAN;

        Test.startTest();
        String result = PartnerSignupFormController.uploadFileOnAccount(acc.Id, testFileName, testBase64Data, testFileTitle);
        Test.stopTest();

        System.assertEquals(PartnerSignupFormConstants.SUCCESS_MESSAGE, result);
        System.assertNotEquals(PartnerSignupFormConstants.FAILED_MESSAGE,result);
    }
    
    //This method is used to upload file in account when file title is comCertPdf
    @isTest
    static void testUploadFileOnAccountWithCompCertFile () {
        
        Account  acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String testFileName = 'test.pdf';
        String testBase64Data = 'JVBERi0xLjYNJeLjz9MNCjEwNTkgMCBvYmoNPDwvTGluZWFyaXplZCAxL0wgMjExMjM5L08gMTA2Mi9FIDE3MTE4Ni9OIDUvVCAyMTA4MDkvSCBbIDUyNCAyOTNdPj4NZW5kb2JqDSAgICAgICAgICAgDQoxMDgyIDAgb2JqDTw8L0RlY29kZVBhcm1zPDwvQ29sdW1ucyA1L1ByZWRpY3RvciAxMj4';
        String testFileTitle = PartnerSignupFormConstants.COMP_CERT;

        Test.startTest();
        String result = PartnerSignupFormController.uploadFileOnAccount(acc.Id, testFileName, testBase64Data, testFileTitle);
        Test.stopTest();

        System.assertEquals(PartnerSignupFormConstants.SUCCESS_MESSAGE, result);
        System.assertNotEquals(PartnerSignupFormConstants.FAILED_MESSAGE,result);
    }
    
    //This method is used to upload file in account when file title is canChePdf
    @isTest
    static void testUploadFileOnAccountWithCancelChequeFile() {
        
        Account  acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        String testFileName = 'test.pdf';
        String testBase64Data = 'JVBERi0xLjYNJeLjz9MNCjEwNTkgMCBvYmoNPDwvTGluZWFyaXplZCAxL0wgMjExMjM5L08gMTA2Mi9FIDE3MTE4Ni9OIDUvVCAyMTA4MDkvSCBbIDUyNCAyOTNdPj4NZW5kb2JqDSAgICAgICAgICAgDQoxMDgyIDAgb2JqDTw8L0RlY29kZVBhcm1zPDwvQ29sdW1ucyA1L1ByZWRpY3RvciAxMj4';
        String testFileTitle = PartnerSignupFormConstants.CAN_CHEQUE;

        Test.startTest();
        String result = PartnerSignupFormController.uploadFileOnAccount(acc.Id, testFileName, testBase64Data, testFileTitle);
        Test.stopTest();

        System.assertEquals(PartnerSignupFormConstants.SUCCESS_MESSAGE, result);
        System.assertNotEquals(PartnerSignupFormConstants.FAILED_MESSAGE,result);
    }
    
}