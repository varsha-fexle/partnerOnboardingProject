public class ContactFormBean {

    @AuraEnabled
    public String firstName {get; set;}
    @AuraEnabled
    public String lastName {get; set;}
    public String title {get; set;}
    @AuraEnabled
    public String email {get; set;}
    @AuraEnabled
    public String gender {get; set;}
    @AuraEnabled
    public String mobileNumber {get; set;}
    @AuraEnabled
    public String aadharCard {get; set;}
    @AuraEnabled
    public String panCardNumber {get; set;}
    public boolean isIndividual {get; set;}
    public String partnerType {get; set;}
    public String conId {get; set;}
    public String employeeId {get; set;}
    public Date birthDate {get; set;}
    public String mailingStreet {get; set;}
    public String mailingCity {get; set;}
    public String mailingPostalCode {get; set;}
    public String mailingState {get; set;}
    public String mailingCountry {get; set;}
    public String otherStreet {get; set;}
    public String otherCity {get; set;}
    public String otherPostalCode {get; set;}
    public String otherState {get; set;}
    public String otherCountry {get; set;}
    public String emergencyContactName {get; set;}
    public String emergencyContactNumber {get; set;}
    public String accountId {get; set;}
    @AuraEnabled
    public Boolean isPrimaryContact {get; set;}
    public String id{get;set;}
   
}