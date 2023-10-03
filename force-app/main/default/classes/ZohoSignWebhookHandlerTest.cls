@isTest
private class ZohoSignWebhookHandlerTest {

    @testSetup 
    static void setData() {
        
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Partner_Onboarding' LIMIT 1];

        PermissionSetAssignment assignmentRecord;
        List<PermissionSetAssignment> assignmentRecords = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :currentUser.Id AND PermissionSetId = :permissionSet.Id LIMIT 1];
        
        if (assignmentRecords.size() > 0) {
            assignmentRecord = assignmentRecords[0];
        } else {
            PermissionSetAssignment perSetAssign = new PermissionSetAssignment();
            perSetAssign.AssigneeId = currentUser.Id;
            perSetAssign.PermissionSetId = permissionSet.Id;
            insert perSetAssign;
            assignmentRecord = perSetAssign; // Assign the newly inserted record to assignmentRecord
        }
        
        Account acc = new Account(Name = 'Test Account',NDA_Document_Id__c = 'NDA123', NDA_Document_Status__c = 'Signed',MSA_Document_Status__c = 'Signed',MSA_Document_Id__c = 'MSA456');
   		insert acc;
    }
    @isTest
    static void testHandlePost_NDADocument() {
        
        // Create a mock request with JSON data for an NDA document
        String requestBody = '{"requests": {"document_ids": [{"document_id": "NDA123", "document_name": "NDA FEXLE"}]}}';
        RestRequest req = new RestRequest();
        req.requestURI = '/api/Webhooks/ZohoWebhookHandler/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Call the method to be tested
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ZohoSignServiceMock());
        ZohoSignWebhookHandler.handlePost();
        Test.stopTest();

        // Verify the changes in the database
        List<Account> updatedAccounts = [SELECT NDA_Document_Status__c FROM Account WHERE NDA_Document_Id__c = 'NDA123'];
        System.assertEquals('Signed', updatedAccounts[0].NDA_Document_Status__c);
    }

    @isTest
    static void testHandlePost_MSADocument() {
        // Create a mock request with JSON data for an MSA document
        String requestBody = '{"requests": {"document_ids": [{"document_id": "MSA456", "document_name": "Vendor Agreement - Draft"}]}}';
        RestRequest req = new RestRequest();
        req.requestURI = '/api/Webhooks/ZohoWebhookHandler/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        // Call the method to be tested
        Test.startTest();
        ZohoSignWebhookHandler.handlePost();
        Test.stopTest();

        // Verify the changes in the database
        List<Account> updatedAccounts = [SELECT MSA_Document_Status__c FROM Account WHERE MSA_Document_Id__c = 'MSA456'];
        System.assertEquals('Signed', updatedAccounts[0].MSA_Document_Status__c);
    }
}