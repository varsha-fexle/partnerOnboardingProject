public class ZohoSignWrapper {
    public Templates templates { get; set; }
    //public Requests requests { get; set; }
    //public Notifications notifications { get; set; }
    public class Templates {
        public FieldData field_data { get; set; }
        public List<Action> actions { get; set; }
        public String notes { get; set; }
    }

    public class FieldData {
        public FieldTextData field_text_data { get; set; }
        public FieldBooleanData field_boolean_data { get; set; }
        public FieldDateData field_date_data { get; set; }
        public FieldRadioData field_radio_data { get; set; }
    }

    public class FieldTextData {
        public String VendorName { get; set; }
        public String Company { get; set; }
    }

    public class FieldBooleanData {

    }

    public class FieldDateData {

    }

    public class FieldRadioData {
        
    }

    public class Action {
        public String recipient_name { get; set; }
        public String recipient_email { get; set; }
        public String action_id { get; set; }
        public String role { get; set; }
        public Boolean verify_recipient { get; set; }
        public String private_notes { get; set; }
        public Integer signing_order {get;set;}
    }

      
    
    public class Requests {
        public String request_status { get; set; }
        public String owner_email { get; set; }
        public List<DocumentIds> document_ids { get; set; }
        public Boolean self_sign { get; set; }
        public String owner_id { get; set; }
        public String request_name { get; set; }
        public Long modified_time { get; set; }
        public Long action_time { get; set; }
        public Boolean is_deleted { get; set; }
        public Boolean is_sequential { get; set; }
        public String owner_first_name { get; set; }
        public String request_type_name { get; set; }
        public String owner_last_name { get; set; }
        public String request_id { get; set; }
        public String request_type_id { get; set; }
        public String zsdocumentid { get; set; }
        public List<Actions> actions { get; set; }
    }
    
    public class DocumentIds {
        public String document_name { get; set; }
        public Integer document_size { get; set; }
        public String document_order { get; set; }
        public Boolean is_editable { get; set; }
        public Integer total_pages { get; set; }
        public String document_id { get; set; }
    }
    
    public class Actions {
        public Boolean verify_recipient { get; set; }
        public String action_type { get; set; }
        public String action_id { get; set; }
        public Boolean is_revoked { get; set; }
        public String recipient_email { get; set; }
        public Boolean is_embedded { get; set; }
        public Integer signing_order { get; set; }
        public String recipient_name { get; set; }
        public Boolean allow_signing { get; set; }
        public String recipient_phonenumber { get; set; }
        public String recipient_countrycode { get; set; }
        public String action_status { get; set; }
    }
    
    public class Notifications {
        public String performed_by_email { get; set; }
        public Long performed_at { get; set; }
        public String country { get; set; }
        public String activity { get; set; }
        public String operation_type { get; set; }
        public Decimal latitude { get; set; }
        public String performed_by_name { get; set; }
        public String ip_address { get; set; }
        public Decimal longitude { get; set; }
    }
}