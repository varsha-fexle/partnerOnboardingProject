public class ZohoSignResponseParser {
    
     
    public static Response sendDocOutForSignResp (String responseBody) {
        return (Response)JSON.deserialize(responseBody,Response.class);
    }

         public class TextProperty {
            public Boolean is_italic;
            public Integer max_field_length;
            public Boolean is_underline;
            public String font_color;
            public Boolean is_fixed_width;
            public Integer font_size;
            public Boolean is_fixed_height;
            public Boolean is_read_only;
            public Boolean is_bold;
            public String font;
        }
        
        public class Field {
            public String field_id;
            public Integer x_coord;
            public String field_type_id;
            public Integer abs_height;
            public TextProperty text_property;
            public String field_category;
            public String field_label;
            public Boolean is_mandatory;
            public String default_value;
            public Integer page_no;
            public String document_id;
            public String field_name;
            public Decimal y_value;
            public Decimal abs_width;
            public Decimal width;
            public String field_value;
            public Decimal y_coord;
            public String field_type_name;
            public String description_tooltip;
            public Decimal x_value;
            public Decimal height;
        }
        
        public class Document {
            public String document_id;
            public List<Field> fields;
        }
        
        public class Action {
            public Boolean verify_recipient;
            public String recipient_countrycode_iso;
            public String action_type;
            public String private_notes;
            public String cloud_provider_name;
            public Boolean has_payment;
            public String recipient_email;
            public Boolean send_completed_document;
            public Boolean allow_signing;
            public String recipient_phonenumber;
            public Boolean is_bulk;
            public String action_id;
            public Boolean is_revoked;
            public Boolean is_embedded;
            public Integer cloud_provider_id;
            public Integer signing_order;
            public List<Field> fields;
            public String recipient_name;
            public String delivery_mode;
            public String action_status;
            public String recipient_countrycode;
        }
        
        public class Request {
            public List<Document> document_ids;
            public List<Action> actions;
            // Other properties...
        }
        
        public class Response {
            public Integer code;
            public Request requests;
            public String message;
            public String status;
        }



}