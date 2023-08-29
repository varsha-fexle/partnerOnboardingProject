public class PartnerSignupExceptionHandler {
    
    // Log an exception with relevant details
    public static void logException(String details, Integer lineNumber, String methodName, String className) {
        try {
            // Create a new Log_Exception__c record
            Partner_Onboarding_Exception__c excep = new Partner_Onboarding_Exception__c();
            
            // Validate and sanitize input details
            excep.Exception_Details__c = details;
            excep.Line_Number__c = lineNumber;
            excep.Method_Name__c = methodName; 
            excep.Class_Name__c = className;
            
            // Insert the Log_Exception__c record
            insert excep;
        } catch (Exception e) {
            // Handle the exception if insertion fails
            System.debug('Error while logging exception: ' + e.getMessage());
        }
    }
}