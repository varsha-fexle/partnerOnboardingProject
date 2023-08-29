/** 
* 
* Description   : This class is used to build requests to integrate Zoho
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
public without sharing class ZohoSignRequestBuilder {

    /* This method is used to generate an Access Token for Zoho Sign API */
    public static String generateAccessToken() {
        try {
            ZohoSign_Master_Settings__c zoho_Settings = ZohoSign_Master_Settings__c.getOrgDefaults();
            HttpRequest request = new HttpRequest();
            String endpoint = zoho_Settings.Access_Token_Endpoint__c;
            endpoint += ZohoSignConstants.CLIENT_ID + zoho_Settings.Client_Id__c + ZohoSignConstants.CLIENT_SECRET + zoho_Settings.Client_Secret__c + ZohoSignConstants.REDIRECT_URI + zoho_Settings.Redirect_URI__c + ZohoSignConstants.GRANT_TYPE + zoho_Settings.Grant_Type__c + ZohoSignConstants.REFRESH_TOKEN + zoho_Settings.Refresh_Token__c;
            request.setMethod(ZohoSignConstants.METHOD_TYPE_POST);
            request.setEndpoint(endpoint);        
            request.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response != null && response.getBody() != null) {
                 Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                 return (String)results.get(ZohoSignConstants.ACCESS_TOKEN);
            } 
        } catch(Exception e) {
        	PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'generateAccessToken','ZohoSignRequestBuilder');
        }
        return null;
       
    }

     /* This method builds an HttpRequest object with the necessary headers and body */
     public static HttpRequest buildRequest(String endpoint, String body, String methodType) {
        
        try {
            String accessToken = generateAccessToken();
            
            if (accessToken != null) {
                Map<String, String> dataMap = new Map<String, String>();
                dataMap.put(ZohoSignConstants.DATA, body);
                dataMap.put(ZohoSignConstants.IS_QUICK_SEND, 'true');
                String requestBody = '';
                for (String key : dataMap.keySet()) {
                    String value = EncodingUtil.urlEncode(dataMap.get(key), 'UTF-8');
                    if (requestBody != '') {
                        requestBody += '&';
                    }
                    requestBody += key + '=' + value;
                }
                 
                String authorizationHeader = ZohoSignConstants.REQUEST_HEADER_AUTHORIZATION_TYPE +' '+accessToken;
                //Create an HttpRequest object
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endPoint);
                req.setMethod(methodType);
                req.setHeader(ZohoSignConstants.REQUEST_HEADER_AUTHORIZATION, authorizationHeader);
                req.setHeader(ZohoSignConstants.REQUEST_HEADER_CONTENT_TYPE, ZohoSignConstants.REQUEST_HEADER_CONTENT_TYPE_APPLICATION_JSON);
                req.setTimeout(120000);
                if (dataMap != null) {
                    req.setBody(requestBody);
                }
                return req;
            }
        }
        catch(Exception e) {
        	PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'buildRequest','ZohoSignRequestBuilder');
        }
        return null;
    }
    
    /*
    This method creates an HttpRequest object for sending a document for signing using the NDA template.
    @param email The email address of the recipient
    @param recepientName The name of the recipient
    @param companyName The name of the company
    @return An HttpRequest object for sending the document for signing
    */
    public static HttpRequest sendDocumentForSignForNDA(String email,String recepientName,String companyName) {
        try {
            ZohoSign_Master_Settings__c zohoSettings = ZohoSign_Master_Settings__c.getOrgDefaults();
            String endpoint = zohoSettings.base_url__c + zohoSettings.version__c + '/templates/'+zohoSettings.nda_template_id__c+'/createdocument';
            return buildRequest(
                        endpoint,
                        ZohoSignRequestJSONBodyBuilder.createJsonForSendDocForSign(email, recepientName, zohoSettings.nda_action_id__c, companyName),
                        ZohoSignConstants.METHOD_TYPE_POST);
        }
        catch(Exception e) {
            PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'sendDocumentForSignForNDA','ZohoSignRequestBuilder');
        }
        return null;
    }
    
    /*
    This method creates an HttpRequest object for sending a document for signing using the MSA template.
    @param email The email address of the recipient
    @param recepientName The name of the recipient
    @param companyName The name of the company
    @return An HttpRequest object for sending the document for signing
    */
    public static HttpRequest sendDocumentForSignForMSA(String email,String recepientName, String companyName) {
        try {
            ZohoSign_Master_Settings__c zohoSettings = ZohoSign_Master_Settings__c.getOrgDefaults();
            String endpoint = zohoSettings.base_url__c + zohoSettings.version__c + '/templates/'+zohoSettings.msa_template_id__c+'/createdocument';
            return buildRequest(
                        endpoint,
                        ZohoSignRequestJSONBodyBuilder.createJsonForSendDocForSign(email, recepientName, zohoSettings.msa_action_id__c, companyName),
                        ZohoSignConstants.METHOD_TYPE_POST);
        }
        catch(Exception e) {
            PartnerSignupExceptionHandler.logException(e.getMessage(),e.getLineNumber(),'sendDocumentForSignForMSA','ZohoSignRequestBuilder');
        }
        return null;
    }
}