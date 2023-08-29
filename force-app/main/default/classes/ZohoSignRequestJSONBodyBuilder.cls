/** 
* 
* Description   : This class provides a method to create a JSON request body for sending a document for signing via Zoho Sign API.
* 
* Created By    : Varsha Adwani
* 
* Created Date  : 11/08/2023
* 
**/
public class ZohoSignRequestJSONBodyBuilder {

     /**
     * Creates a JSON request body for sending a document for signing.
     *
     * @param email         The email address of the recipient.
     * @param recepientName The name of the recipient.
     * @param actionId      The ID of the action.
     * @param companyName   The name of the company.
     * @return A JSON representation of the document signing request.
     */
     public static String createJsonForSendDocForSign(String email, String recepientName, String actionId, String companyName) {
         
		// Create instances for different components of the Zoho Sign request
        ZohoSignWrapper zohoSignWrap = new ZohoSignWrapper();
        ZohoSignWrapper.Templates zohoTemplate = new ZohoSignWrapper.Templates();
        ZohoSignWrapper.FieldData zohoFieldData = new ZohoSignWrapper.FieldData();
        ZohoSignWrapper.FieldTextData zohoFieldtextData = new ZohoSignWrapper.FieldTextData();
        ZohoSignWrapper.FieldBooleanData zohoFieldBooleanData = new ZohoSignWrapper.FieldBooleanData();
        ZohoSignWrapper.FieldDateData zohoFieldDateData = new ZohoSignWrapper.FieldDateData();
        ZohoSignWrapper.FieldRadioData zohoFieldRadioData = new ZohoSignWrapper.FieldRadioData();
        
        // Populate text data with recipient and company information
        zohoFieldtextData.VendorName = recepientName;
        zohoFieldtextData.Company = companyName;

        // Assign different field data components to the main field data         
        zohoFieldData.field_text_data = zohoFieldtextData;
        zohoFieldData.field_boolean_data = zohoFieldBooleanData;
        zohoFieldData.field_date_data = zohoFieldDateData;
        zohoFieldData.field_radio_data = zohoFieldRadioData;
        
        // Assign the field data to the template
        zohoTemplate.field_data = zohoFieldData;
        
        // Create and configure the action to be taken for the signing request
        List<ZohoSignWrapper.Action> zohoAction = new List<ZohoSignWrapper.Action>();
        ZohoSignWrapper.Action action = new ZohoSignWrapper.Action();
        action.recipient_name = recepientName;
        action.recipient_email = email;
        action.action_id = actionId;
        action.role = '';
        action.verify_recipient = false;
        action.private_notes = '';
        action.signing_order = 1;

        // Add the action to the list of actions
        zohoAction.add(action);
        zohoTemplate.actions = zohoAction;
        zohoTemplate.notes = '';
         
        // Assign the template to the main wrapper
        zohoSignWrap.templates = zohoTemplate;

        // Serialize the wrapper object into a JSON string
        String jsonString = JSON.serialize(zohoSignWrap);

        System.debug(jsonString);

        // Return the generated JSON string
        return jsonString;

    }

}