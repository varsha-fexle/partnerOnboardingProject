/** 
* 
* Description   : This class is a test class of ContactHelper class.
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
@isTest
public class ContactHelperTest {

    // This method is used to test the functionality of handlePrimaryContactOnAccount method
    @isTest
    static void testHandlePrimaryContactOnAccount() {
        // Create test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test Contacts associated with the test Account
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact contact = new Contact();
            contact.FirstName = 'Test' + i;
            contact.LastName = 'Contact';
            contact.Email = 'test@example.com';
            contact.AccountId = testAccount.Id;
            contact.Title = 'Resource';
            contact.Gender__c = 'Male';
            contact.Is_Primary_Contact__c = true;
            contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.CON_EXTERNAL_REC_TYPE).getRecordTypeId();
            
            testContacts.add(contact);
        }
        insert testContacts;

        // Prepare the List<List<Contact>> for the invocable method
        List<List<Contact>> contactList = new List<List<Contact>>();
        contactList.add(testContacts);

        // Call the invocable method
        Test.startTest();
        ContactHelper.handlePrimaryContactOnAccount(contactList);
        Test.stopTest();

        // Verify that Is_Primary_Contact__c was updated to false for all contacts
        List<Contact> updatedContacts = [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE Id IN :testContacts];
        for (Contact con : updatedContacts) {
            System.assertEquals(false, con.Is_Primary_Contact__c);
        }

        // Verify that no new Contact records were created
        List<Contact> newContacts = [SELECT Id, FirstName, Is_Primary_Contact__c FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(5, newContacts.size());
    }
}