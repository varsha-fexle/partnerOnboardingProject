public class AccountFormBean {
    @AuraEnabled
    public String accountName {get; set;}
    @AuraEnabled
    public String website {get; set;}
    @AuraEnabled
    public String gstNumber {get; set;}
    @AuraEnabled
    public String companyPANNumber {get; set;}
    @AuraEnabled
    public String primaryContactId{get;set;}
    @AuraEnabled
    public String accountId{get;set;}
    @AuraEnabled
    public String gender {get; set;}

    //Billing Address
    @AuraEnabled
    public String accountBillingStreet {get; set;}
    @AuraEnabled
    public String accountBillingCity {get; set;}
    @AuraEnabled
    public String accountBillingState {get; set;}
    @AuraEnabled
    public String accountBillingPostalCode {get; set;}
    @AuraEnabled
    public String accountBillingCountry {get; set;}

    //Bank Details
    @AuraEnabled
    public String accountHolderName  {get; set;}
    @AuraEnabled
    public String bankName {get; set;}
    @AuraEnabled
    public String brachAddress {get; set;}
    @AuraEnabled
    public String accountNumber {get; set;}
    @AuraEnabled
    public String ifscCode {get; set;}

    //Personal Information
    @AuraEnabled
    public String firstName {get; set;}
    @AuraEnabled
    public String lastName {get; set;}
    @AuraEnabled
    public String email {get; set;}
    @AuraEnabled
    public String mobileNumber {get; set;}
    @AuraEnabled
    public String aadharCard {get; set;}
    @AuraEnabled
    public String panCardNumber {get; set;}

}