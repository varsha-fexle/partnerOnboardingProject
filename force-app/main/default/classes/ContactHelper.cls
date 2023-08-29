/** 
* 
* Description   : This class is a helper class of Record_Triggered_Contact_After_Save flow.
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
public class ContactHelper {
    
   //This method is used to set false in Is Primary Contact field of contacts
   @InvocableMethod
   public Static void handlePrimaryContactOnAccount(List<List<Contact>> contactList){
       try {
           List<Contact> conListToUpdate = new List<Contact>();
           if(!contactList[0].isEmpty()) {
               for(Contact con : contactList[0])
               {
                   con.Is_Primary_Contact__c = false;
                   conListToUpdate.add(con);
               }
           }
           
           if(!conListToUpdate.isEmpty()){
               update conListToUpdate;
           }
           
           List<Contact> newContact = [Select Id, FirstName, Is_Primary_Contact__c From Contact Where AccountId =:conListToUpdate[0].AccountId];
           
       } catch(Exception e) {
           
           // Log any exceptions that occur
           PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'handlePrimaryContactOnAccount','ContactHelper');
       }
   }
}