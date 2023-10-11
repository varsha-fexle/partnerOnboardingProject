/** 
* 
* Description : This is a ZohoSignService class to send the document for sign from Zoho.
* 
* Created By : Varsha Adwani
* 
* Created Date : 11/08/2023
* 
**/
public class ZohoSignService {

    // This method is invoked from an external source to send documents for signing.
    @InvocableMethod
    public static void sendDocumentForSign(List<String> accountIds) {
        sendDocumentForSignAsync(accountIds); // Delegate the actual work to an asynchronous method.
    }

    // Asynchronous method to send documents for signing.
    @future(callout=true)
    public static void sendDocumentForSignAsync(List<String> accountIds) {

        try {
            // Fetch necessary data from the Account record.
            Account accountRecord = [SELECT RecordTypeId From Account WHERE Id =:accountIds[0] LIMIT 1];
            Account account = new Account();
            if (isPersonAccount(accountRecord)) {
                account = [SELECT Id, RecordTypeId, Verification_Status__c, NDA_Document_Id__c, MSA_Document_Id__c, Onboarding_Status__c, PersonEmail, FirstName, LastName, BillingStreet, BillingCity, BillingState, BillingPostalCode
                FROM Account WHERE Id = :accountIds[0] LIMIT 1];
            } else {
                account = [SELECT Id, Name, RecordTypeId, Verification_Status__c, NDA_Document_Id__c, MSA_Document_Id__c, Onboarding_Status__c, BillingStreet, BillingCity, BillingState, BillingPostalCode
                FROM Account WHERE Id = :accountIds[0] LIMIT 1];     
            }
        

            if (account == null) {
                return; // If account data is not found, return early.
            }

            String email = '';
            String recepientName = '';
            String companyName = '';
            String billingAddress = '';

            if (isPersonAccount(account)) {
                // If the account is a person account, set details accordingly.
                email = account.PersonEmail;
                recepientName = account.FirstName + ' ' + account.LastName;
                billingAddress = account.BillingStreet + ' ' + account.BillingCity + ' ' + account.BillingState + ' ' + account.BillingPostalCode;
                companyName = recepientName;
            } else {
                // If the account is not a person account, fetch primary contact details.
                Contact primaryContact = fetchPrimaryContact(accountIds[0]);

                if (primaryContact != null) {
                    email = primaryContact.Email;
                    recepientName = primaryContact.Name;
                    companyName = account.Name;
                    billingAddress = account.BillingStreet + ' ' + account.BillingCity + ' ' + account.BillingState + ' ' + account.BillingPostalCode;
                }
            }

            // Build and send requests to ZohoSign for NDA and MSA documents.
            HttpRequest requestFirst = ZohoSignRequestBuilder.sendDocumentForSignForNDA(email, recepientName, companyName, billingAddress);
            Http httpForNda = new Http();
            HttpResponse responseFirst = httpForNda.send(requestFirst);
            ZohoSignResponseParser.Response resultForNdaDoc = ZohoSignResponseParser.sendDocOutForSignResp(responseFirst.getBody());
            System.debug(resultForNdaDoc);

            HttpRequest requestSecond = ZohoSignRequestBuilder.sendDocumentForSignForMSA(email, recepientName, companyName, billingAddress);
            Http httpForMsa = new Http();
            HttpResponse responseSecond = httpForMsa.send(requestSecond);
            ZohoSignResponseParser.Response resultForMsaDoc = ZohoSignResponseParser.sendDocOutForSignResp(responseSecond.getBody());
            System.debug(resultForMsaDoc);

            // Update account fields based on the ZohoSign responses.
            if (account.Verification_Status__c == 'Pending Verification') {
                account.Verification_Status__c = 'Verified';
            } else if (account.Onboarding_Status__c == 'Onboarding Requested') {
                account.Onboarding_Status__c = 'Signature Pending';
            }

            if (resultForNdaDoc != null && resultForNdaDoc.requests != null && !resultForNdaDoc.requests.document_ids.isEmpty()) {
                account.NDA_Document_Id__c = resultForNdaDoc.requests.document_ids[0].document_id;
            }
            if (resultForMsaDoc != null && resultForMsaDoc.requests != null && !resultForMsaDoc.requests.document_ids.isEmpty()) {
                account.MSA_Document_Id__c = resultForMsaDoc.requests.document_ids[0].document_id;
            }

            if (resultForNdaDoc != null && resultForMsaDoc != null && account.NDA_Document_Id__c != null && account.MSA_Document_Id__c != null) {
                update account; // Update the account with the modified fields.
            }

        } catch (Exception e) {
            // Handle any exceptions that occur during the process and log them.
            PartnerSignupExceptionHandler.logException(e.getMessage(), e.getLineNumber(), 'sendDocumentForSignAsync', 'ZohoSignService');
        }
    }

    // Fetches the primary Contact associated with the provided account ID.
    public static Contact fetchPrimaryContact(String accountId) {
        return [SELECT Id, Email, Name FROM Contact WHERE AccountId = :accountId AND Is_Primary_Contact__c = true LIMIT 1];
    }

    // Checks if the provided Account is a person account.
    public static Boolean isPersonAccount(Account account) {
        return account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.PERSON_ACC_REC_TYPE_NAME).getRecordTypeId();
    }
}