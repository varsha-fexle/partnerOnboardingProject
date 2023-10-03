/** 
* 
* Description   : This class is a wrapper class of ZohoSignWebhookHandler
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
public class ZohoSignWebhookWrapper {
   
    public Requests requests { get; set; }

    public class Requests {
        public List<DocumentIds> document_ids { get; set; }
    }
    
    public class DocumentIds {
        public String document_name { get; set; }
        public String document_id { get; set; }
    }
}