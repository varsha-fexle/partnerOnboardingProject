@RestResource(urlMapping='/api/Webhooks/ZohoWebhookHandler/*')
global without sharing class ZohoWebhookHandler {
    
    // Method to handle POST request
    @HttpPost
    global static void handlePost() {
        
        RestResponse res = RestContext.response;

        // Get the request body data
        String requestBody = RestContext.request.requestBody.toString();

        ZohoWebhookWrapper wrapper = (ZohoWebhookWrapper)JSON.deserialize(requestBody, ZohoWebhookWrapper.class);
        
        if(wrapper != NULL) {
          
            List<Account> accListToUpd = new List<Account>();
            if(wrapper.requests.document_ids[0].document_name != NULL && wrapper.requests.document_ids[0].document_name == 'NDA FEXLE') {
                
                String ndaDocumentId = wrapper.requests.document_ids[0].document_id;
                accListToUpd = [SELECT NDA_Document_Id__c,NDA_Document_Status__c FROM Account WHERE NDA_Document_Id__c =:ndaDocumentId LIMIT 1];
                accListToUpd[0].NDA_Document_Status__c = 'Signed';
            } 
            else if(wrapper.requests.document_ids[0].document_name != NULL && wrapper.requests.document_ids[0].document_name == 'Vendor Agreement - Draft') {
                 
                String msaDocumentId = wrapper.requests.document_ids[0].document_id;
                accListToUpd = [SELECT MSA_Document_Id__c,MSA_Document_Status__c FROM Account WHERE MSA_Document_Id__c =:msaDocumentId LIMIT 1];
                accListToUpd[0].MSA_Document_Status__c = 'Signed';
            }
            if (!accListToUpd.isEmpty()) {
                try {
                    update accListToUpd;
                } catch (DmlException e) {
                     PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'handlePost','ZohoWebhookHandler');
                }
           }
        }
    }
}