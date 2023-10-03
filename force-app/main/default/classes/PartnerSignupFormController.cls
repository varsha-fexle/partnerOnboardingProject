/**
  * Created By       : Varsha Adwani
  * Last Modified On : 21 March 2023
  * Purpose          : To create different Types of account and for uploading file
**/
public without sharing class PartnerSignupFormController {
    
   /*
    * Description :- This method is used to create Person Account by JSON string which contains key as account field 
    * 				  and value as account's field value and it returns person accountId
    */
    @AuraEnabled
    public static String createPersonAccount(String accountInfoJSON){
        try{
            String recordId;
            if(accountInfoJSON != null || !string.isEmpty(accountInfoJSON)) {
                AccountFormBean accountInfo = new AccountFormBean();
                accountInfo = (AccountFormBean)JSON.deserialize(accountInfoJSON,AccountFormBean.Class);

                Account personAccount = prepareAccountInstance(accountInfo);
                personAccount.FirstName = accountInfo.firstName;
                personAccount.LastName = accountInfo.lastName;
                personAccount.PersonEmail = accountInfo.email;
                personAccount.PersonMobilePhone = accountInfo.mobileNumber;
                personAccount.Aadhar_Card_Number__pc = accountInfo.aadharCard;
                personAccount.PAN_Number__pc = accountInfo.panCardNumber;
                personAccount.Type = PartnerSignupFormConstants.Type;
                personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.PERSON_ACC_REC_TYPE_NAME).getRecordTypeId();
                insert personAccount;
                recordId = personAccount.Id;
            }
            return recordId;

        } catch(Exception e) {
            return e.getMessage();
        }
       
    }
    
    /*
     * Description :- This method is used to prepare account instance from wrapper class object 
     */
    public static Account prepareAccountInstance(AccountFormBean accountInfo)
    {
        Account accountInstance = new Account();
        //Billing Address
        accountInstance.BillingStreet = accountInfo.accountBillingStreet;
        accountInstance.BillingCity = accountInfo.accountBillingCity;
        accountInstance.BillingState = accountInfo.accountBillingState;
        accountInstance.BillingPostalCode = accountInfo.accountBillingPostalCode;
        accountInstance.BillingCountry = accountInfo.accountBillingCountry;

        //Bank Details
        accountInstance.Bank_Account_Holder_Name__c = accountInfo.accountHolderName;
        accountInstance.Bank_Name__c = accountInfo.bankName;
        accountInstance.Bank_Branch_Address__c = accountInfo.brachAddress;
        accountInstance.Bank_Account_Number__c = accountInfo.accountNumber;
        accountInstance.Bank_IFSC_Code__c = accountInfo.ifscCode;
        return accountInstance;
       
    }
    
    /*
     * Description :- This method is used to fetch 'company accounts' and it returns accountId 
     */
    @AuraEnabled
    public static AccountFormBean getAccount(String accountName, String accountWebsite) {
        System.debug(accountName);
        try{

            Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
            System.debug(RecordTypeId);
            String queryString = 'SELECT Id, Name, Website, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, GST_Number__c, PAN_Number__c, Bank_Account_Holder_Name__c, Bank_Account_Number__c, Bank_Branch_Address__c, Bank_IFSC_Code__c, 	Bank_Name__c FROM Account WHERE RecordTypeId =:RecordTypeId AND';

            if(accountName != null) {

                queryString += ' Name =:accountName AND';
            }

            if(accountWebsite != null) {

                String WebsiteName = '%' + String.escapeSingleQuotes(accountWebsite) + '%';
                queryString += ' Website LIKE :WebsiteName AND';
            }

            queryString = queryString.substring(0,queryString.length()-4);
            queryString += ' LIMIT 1';
            System.debug(queryString);
            List<Account> resultList = Database.query(queryString);
            System.debug('abc '+resultList[0].Id);
            AccountFormBean accountDetails = new AccountFormBean();
            
            if(!resultList.isEmpty()){
            
                Account account = resultList[0];
                accountDetails.accountId = account.Id;
                accountDetails.accountName = resultList.size() > 0 ? resultList[0].Name : '';
                accountDetails.website = resultList.size() > 0 ? resultList[0].Website : '';
                accountDetails.accountBillingStreet = resultList.size() > 0 ? resultList[0].BillingStreet : '';
                accountDetails.accountBillingCity = resultList.size() > 0 ? resultList[0].BillingCity : '';
                accountDetails.accountBillingCountry = resultList.size() > 0 ? resultList[0].BillingCountry : '';
                accountDetails.accountBillingState = resultList.size() > 0 ? resultList[0].BillingState : '';
                accountDetails.accountBillingPostalCode = resultList.size() > 0 ? resultList[0].BillingPostalCode : '';
                accountDetails.accountHolderName = resultList.size() > 0 ? resultList[0].Bank_Account_Holder_Name__c : '';
                accountDetails.bankName = resultList.size() > 0 ? resultList[0].Bank_Name__c : '';
                accountDetails.brachAddress = resultList.size() > 0 ? resultList[0].Bank_Branch_Address__c : '';
                accountDetails.accountNumber = resultList.size() > 0 ? resultList[0].Bank_Account_Number__c : '';
                accountDetails.ifscCode = resultList.size() > 0 ? resultList[0].Bank_IFSC_Code__c : '';
                accountDetails.gstNumber = resultList.size() > 0 ? resultList[0].GST_Number__c : '';
                accountDetails.companyPANNumber = resultList.size() > 0 ? resultList[0].PAN_Number__c : null;
                
                System.debug(accountDetails);
                return accountDetails;

            } else {
                return null;
            }    
        }   
        catch(Exception e) {
           return null;
        }
    }

    
    /*
     * Description :- This method is used to create 'contact' record by JSON string which contains key as contact field				
     *  			  and value as contact's field value
     */
    @AuraEnabled
    public static String createContact(String contactInfoJSON) {
        try {
            if(contactInfoJSON != null) {
                ContactFormBean contactInfo = new ContactFormBean();
                contactInfo = (ContactFormBean)JSON.deserialize(contactInfoJSON,ContactFormBean.class);
                Contact con = new Contact();
                con.firstName = contactInfo.firstName;
                con.lastName = contactInfo.lastName;
                con.email = contactInfo.email;
                con.Title = PartnerSignupFormConstants.CONTACT_TITLE;
                con.MobilePhone = contactInfo.mobileNumber;
                con.Aadhar_Card_Number__c = contactInfo.aadharCard;
                con.PAN_Number__c = contactInfo.panCardNumber;
                con.AccountId = contactInfo.accountId;
                con.Is_Primary_Contact__c = contactInfo.isPrimaryContact;
                con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.CON_EXTERNAL_REC_TYPE).getRecordTypeId();
                insert con;
                System.debug(con);
                return con.Id;
            }
            return null;
        }catch(Exception e) {
            return e.getMessage();
        }
    }
    
    /*
     * Description :- This method is used to create 'company account' by JSON string which contains key as account field 
     *                and value as account's field value
     */
    @AuraEnabled
    public static string createCompanyAccount(String accountInfoJSON){
        try {
            if(accountInfoJSON != null) {
                AccountFormBean accountInfo = new AccountFormBean();
                accountInfo = (AccountFormBean)JSON.deserialize(accountInfoJSON,AccountFormBean.Class);

                Account partnerAccount = prepareAccountInstance(accountInfo);
                partnerAccount.Name = accountInfo.accountName;
                partnerAccount.Website = accountInfo.website;
                partnerAccount.GST_Number__c = accountInfo.gstNumber;
                partnerAccount.PAN_Number__c = accountInfo.companyPANNumber;
                partnerAccount.Type = PartnerSignupFormConstants.Type;
                partnerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PartnerSignupFormConstants.TYPE).getRecordTypeId();
                
               
                if(!String.isBlank(accountInfo.accountId)) {
                    partnerAccount.Id = accountInfo.accountId;
                   
                }
                   
                upsert partnerAccount;
                return partnerAccount.Id;
                
            }
            return null;
        }catch(Exception e) {
            return e.getMessage();
        }
    }
    
    /*
     * Description :- This method is used to upload file in notes and attachments of particular 'account' 
     *                and it is returning result success or failed 
     */
    @AuraEnabled
    public static string uploadFileOnAccount(Id idParent, String strFileName, String base64Data, String fileTitle) {

        List<Attachment> attachmentList = [SELECT Id, Name FROM Attachment];

        Attachment attachment = new Attachment();
        if( fileTitle == PartnerSignupFormConstants.GST ) {
            attachment.Name = PartnerSignupFormConstants.GST_TITLE;
        } else if( fileTitle == PartnerSignupFormConstants.PAN ) {
            attachment.Name = PartnerSignupFormConstants.PAN_TITLE;
        }  else if( fileTitle == PartnerSignupFormConstants.COMP_CERT ) {
            attachment.Name = PartnerSignupFormConstants.COMP_CERT_TITLE;
        }  else if( fileTitle == PartnerSignupFormConstants.CAN_CHEQUE ) {
            attachment.Name = PartnerSignupFormConstants.CAN_CHEQUE_TITLE;
        } 
    
        attachment.parentId = idParent;
        attachment.Body = EncodingUtil.base64Decode(base64Data);
        List<Attachment> attachListToInsert = new List<Attachment>();
    
        attachListToInsert.add(attachment);
        Database.SaveResult[] srList = Database.insert(attachListToInsert, false);
    
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                return PartnerSignupFormConstants.SUCCESS_MESSAGE;
            }
            else {
                return PartnerSignupFormConstants.FAILED_MESSAGE;
            }
        }
        return null;
    } 
  
    /*
     * Description :- This method is used to check missing attachments in a particular account
     */
    @AuraEnabled
    public static List<String> checkMissingDocuments(String accountId) {
        List<Attachment> attachmentList = [SELECT Id, Name FROM Attachment WHERE parentId =:accountId];
        List<String> missingFiles = new List<String>();
        Boolean isGstExists = false;
        Boolean isPanExists = false;
        Boolean isCanChequeExists = false;
        Boolean isComCertExists = false;
        for(Attachment attach : attachmentList) {
            if(attach.Name == PartnerSignupFormConstants.GST_TITLE) {
                isGstExists = true;
            }
            else if(attach.Name == PartnerSignupFormConstants.PAN_TITLE) {
                isPanExists = true;
            }
            else if(attach.Name == PartnerSignupFormConstants.CAN_CHEQUE_TITLE) {
                isCanChequeExists = true;
            }
            else if(attach.Name == PartnerSignupFormConstants.COMP_CERT_TITLE) {
                isComCertExists = true;
            }
        }
        if(isGstExists == false) {
            missingFiles.add(PartnerSignupFormConstants.GST_TITLE);
        }
        if(isPanExists == false) {
            missingFiles.add(PartnerSignupFormConstants.PAN_TITLE);
        }
        if(isCanChequeExists == false) {
            missingFiles.add(PartnerSignupFormConstants.CAN_CHEQUE_TITLE);
        } 
        if(isComCertExists == false) {
            missingFiles.add(PartnerSignupFormConstants.COMP_CERT_TITLE);
        }
        return missingFiles;
    }

    /*
     * Description :- This method is used to fetch contact by Email and accountId
     */
    @AuraEnabled 
    public static String fetchContact(String email, String accountId) {
        List<Contact> conList = [SELECT Id, Email FROM Contact Where Email=:email AND AccountId =:accountId];
        if(!conList.isEmpty()) {
            return PartnerSignupFormConstants.FOUND;
        } else {
            return PartnerSignupFormConstants.NOT_FOUND;
        }
    }
}