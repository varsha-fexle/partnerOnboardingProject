/** 
* 
* Description   : This class is used to test the functionality of SendEmailToSfAdmins class
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
@isTest
public class SendEmailToSfAdminsTest {

    // Test method to test functionality of sendEmailToSysAdmins method
    @isTest
    static void testSendEmailToSysAdmins() {
        // Create a test user with System Administrator profile
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@example.com',
            Username = 'unique_test_user@example.com', // Replace with a unique username
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            ProfileId = sysAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Set up test data for the EmailTemplates parameter
        List<String> emailTemplates = new List<String>{'<p>Test Email Template</p>'};

        // Start the test and invoke the method
        Test.startTest();
        SendEmailToSfAdmins.sendEmailToSysAdmins(emailTemplates);
        Test.stopTest();

        // Verify the email was sent successfully
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject, HtmlBody FROM EmailMessage];
        System.assertEquals(1, sentEmails.size());
        EmailMessage sentEmail = sentEmails[0];
        
        User user = [SELECT Email FROM User WHERE Email = 'test@example.com' LIMIT 1];
        if(user != NULL) {
            System.assertEquals(sentEmail.ToAddress.contains(user.Email),true);
            System.assertEquals(PartnerSignupFormConstants.ADMIN_EMAIL_SUBJECT, sentEmail.Subject);
            System.assert(sentEmail.HtmlBody.contains('<p>Test Email Template</p>'));
        }
    }
}