/** 
* 
* Description   : This class is used to Send Email to all System Administrations
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
public class SendEmailToSfAdmins {

    /**
     * Sends an email to a list of active system administrators based on a specific user profile.
     * @param EmailTemplates List of email templates (expects a single template string)
     */
    @InvocableMethod
    public static void sendEmailToSysAdmins(List<String> EmailTemplates) {
        try {
            // Retrieve a list of active system administrator's emails
            List<User> adminUsers = [SELECT Email FROM User WHERE Profile.Name =:PartnerSignupFormConstants.PROFILE_NAME_SYSTEM_ADMIN AND IsActive = true and Email != NULL LIMIT 50000];
            List<String> emailList = new List<String>();
            
            if (!adminUsers.isEmpty()) {
                // Extract email addresses from user records
                for (User user : adminUsers) {
                    emailList.add(user.Email);
                }
                
                // Create an email message
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = emailList;
                message.subject = PartnerSignupFormConstants.ADMIN_EMAIL_SUBJECT;
                message.setHtmlBody(EmailTemplates[0]);
                
                // Send the email
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
                
            }
            
        } catch (Exception e) {
            // Log any exceptions that occur
            PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'sendEmailToSysAdmins','SendEmailToSfAdmins');
        }
    }
}