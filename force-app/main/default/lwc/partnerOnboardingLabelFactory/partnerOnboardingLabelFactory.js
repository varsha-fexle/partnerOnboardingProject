import { LightningElement } from 'lwc';
import REQUIRED_FIELD_ERROR from '@salesforce/label/c.Required_Field_Error';
import ONE_VALUE_REQUIRE from '@salesforce/label/c.One_Value_Require';
import INDIVIDUAL_PARTNER_VALUE from '@salesforce/label/c.Individual_Partner_Value';
import INDIVIDUAL_PARTNER_LABEL from '@salesforce/label/c.Individual_Partner_Label';
import PARTNER_VALUE from '@salesforce/label/c.Partner_Value';
import PARTNER_LABEL from '@salesforce/label/c.Partner_Label';
import SEARCH_COMPANY_VALUE from '@salesforce/label/c.Search_Company_Value';
import SEARCH_COMPANY_LABEL from '@salesforce/label/c.Search_Company_Label';
import PERSONAL_INFO from '@salesforce/label/c.Personal_Information';
import CANNOT_BE_UPDATED from '@salesforce/label/c.Cannot_Be_Updated';
import FIND_YOUR_COMPANY from '@salesforce/label/c.Find_Company';
import MANDATORY_LABEL from '@salesforce/label/c.Mandatory_Label';
import READ_CAREFULLY from '@salesforce/label/c.Read_Carefully';
import ACCURATE_INFORMATION from '@salesforce/label/c.Accurate_Information';
import COMPANY_INFO_HEADING from '@salesforce/label/c.Compny_Info';
import THANKYOU_MESSAGE from '@salesforce/label/c.Thankyou_Message';
import THANKYOU_TEXT from '@salesforce/label/c.Thankyou_Text';
import INVALID_EMAIL from '@salesforce/label/c.Invalid_Email';
import BILLING_INFO from '@salesforce/label/c.Billing_Info';
import FIVE_STEPS_GRAPHICS_LABEL from '@salesforce/label/c.Five_Steps_Graphics_Label';
import RESOURCE_DETAILS from '@salesforce/label/c.Resource_Details';
import BANK_INFO from '@salesforce/label/c.Bank_Info';
import INVALID_AADHAR_CARD_NUMBER from '@salesforce/label/c.Invalid_Aadhar_Card_Number';
import CONTACT_INFO from '@salesforce/label/c.Contact_Info';
import REC_ID_LEN from '@salesforce/label/c.Length_of_Record_Id';
import INVALID_WEBSITE from '@salesforce/label/c.Invalid_Website';
import NOT_FOUND from '@salesforce/label/c.Company_Not_Found';
import ACCOUNT_IS_UPDATED from '@salesforce/label/c.Account_Is_Updated';
import FIRST_DIGIT_OF_AADHAR_CARD_NUM_ERROR from '@salesforce/label/c.First_Digit_of_Aadhar_Card_Number';
import ACCOUNT_IS_CREATED from '@salesforce/label/c.Account_Is_Created';
import PERSON_ACCOUNT_IS_CREATED from '@salesforce/label/c.Person_Account_Is_Created';
import RESOURCE_ALREADY_EXISTS from '@salesforce/label/c.Resource_Already_Exists';
import CONTACT_IS_CREATED from '@salesforce/label/c.Contact_Is_Created';
import GST_CERTIFICATE_UPLOADED from '@salesforce/label/c.GST_Uploaded';
import PAN_CARD_UPLOADED from '@salesforce/label/c.Pan_Uploaded';
import COM_CERT_UPLOADED from '@salesforce/label/c.Comp_Cert_Uploaded';
import CANCEL_CHEQUE_UPLOADED from '@salesforce/label/c.Cancel_Cheque_Uploaded';
import FILE_FORMAT from '@salesforce/label/c.File_Format';
import UPLOAD_PDF_FILES from '@salesforce/label/c.Upload_Pdf_Files';
import UPLOAD_COMPLETE from '@salesforce/label/c.Upload_Complete';
import DOCUMENTS_UPLOAD from '@salesforce/label/c.Documents_Upload';
import DOCUMENTS_UPLOADED_SUCCESSFULLY from '@salesforce/label/c.Documents_Uploaded_Successfully';
import GST_CERTIFICATE from '@salesforce/label/c.GST_Certificate';
import PAN_CARD from '@salesforce/label/c.PAN_Card';
import COMPANY_CERTIFICATE from '@salesforce/label/c.Company_Certificate';
import CANCEL_CHEQUE from '@salesforce/label/c.Cancelled_cheque';
import NOT_UPLOADED from '@salesforce/label/c.Not_Uploaded';
import SUCCESS from '@salesforce/label/c.Success';
import GST_PDF from '@salesforce/label/c.GST_Pdf';
import CANCEL_CHEQUE_PDF from '@salesforce/label/c.Cancel_Cheque_Pdf';
import COMPANY_CERTIFICATE_PDF from '@salesforce/label/c.Company_Certificate_Pdf';
import PAN_PDF from '@salesforce/label/c.PAN_Pdf';
import FLOW_FINISHED_STATUS from '@salesforce/label/c.Flow_Finished_Status';
import FINISH_BUTTON_NAME from '@salesforce/label/c.Finish_Button_Name';
import FOUND_TEXT from '@salesforce/label/c.Found_Text';

const labels = {
    "REQUIRED_FIELD_ERROR" : REQUIRED_FIELD_ERROR,
    "ONE_VALUE_REQUIRE" : ONE_VALUE_REQUIRE,
    "INDIVIDUAL_PARTNER_VALUE" : INDIVIDUAL_PARTNER_VALUE,
    "INDIVIDUAL_PARTNER_LABEL" : INDIVIDUAL_PARTNER_LABEL,
    "PARTNER_VALUE" : PARTNER_VALUE,
    "PARTNER_LABEL" : PARTNER_LABEL,
    "SEARCH_COMPANY_VALUE" : SEARCH_COMPANY_VALUE,
    "SEARCH_COMPANY_LABEL" : SEARCH_COMPANY_LABEL,
    "PERSONAL_INFO" : PERSONAL_INFO,
    "CANNOT_BE_UPDATED" : CANNOT_BE_UPDATED,
    "FIND_YOUR_COMPANY" : FIND_YOUR_COMPANY,
    "MANDATORY_LABEL" : MANDATORY_LABEL,
    "READ_CAREFULLY" : READ_CAREFULLY,
    "ACCURATE_INFORMATION" : ACCURATE_INFORMATION,
    "COMPANY_INFO_HEADING" : COMPANY_INFO_HEADING,
    "THANKYOU_MESSAGE" : THANKYOU_MESSAGE,
    "THANKYOU_TEXT" : THANKYOU_TEXT,
    "INVALID_EMAIL" : INVALID_EMAIL,
    "BILLING_INFO" : BILLING_INFO,
    "FIVE_STEPS_GRAPHICS_LABEL" : FIVE_STEPS_GRAPHICS_LABEL,
    "RESOURCE_DETAILS" : RESOURCE_DETAILS,
    "BANK_INFO" : BANK_INFO,
    "INVALID_AADHAR_CARD_NUMBER" : INVALID_AADHAR_CARD_NUMBER,
    "CONTACT_INFO" : CONTACT_INFO,
    "REC_ID_LEN" : REC_ID_LEN,
    "INVALID_WEBSITE" : INVALID_WEBSITE,
    "NOT_FOUND" : NOT_FOUND,
    "ACCOUNT_IS_UPDATED" : ACCOUNT_IS_UPDATED,
    "FIRST_DIGIT_OF_AADHAR_CARD_NUM_ERROR" : FIRST_DIGIT_OF_AADHAR_CARD_NUM_ERROR,
    "ACCOUNT_IS_CREATED" : ACCOUNT_IS_CREATED,
    "PERSON_ACCOUNT_IS_CREATED" : PERSON_ACCOUNT_IS_CREATED,
    "RESOURCE_ALREADY_EXISTS" : RESOURCE_ALREADY_EXISTS,
    "CONTACT_IS_CREATED" : CONTACT_IS_CREATED,
    "GST_CERTIFICATE_UPLOADED" : GST_CERTIFICATE_UPLOADED,
    "PAN_CARD_UPLOADED" : PAN_CARD_UPLOADED,
    "COM_CERT_UPLOADED" : COM_CERT_UPLOADED,
    "CANCEL_CHEQUE_UPLOADED" : CANCEL_CHEQUE_UPLOADED,
    "FILE_FORMAT" : FILE_FORMAT,
    "UPLOAD_PDF_FILES" : UPLOAD_PDF_FILES,
    "UPLOAD_COMPLETE" : UPLOAD_COMPLETE,
    "DOCUMENTS_UPLOAD" : DOCUMENTS_UPLOAD,
    "DOCUMENTS_UPLOADED_SUCCESSFULLY" : DOCUMENTS_UPLOADED_SUCCESSFULLY,
    "GST_CERTIFICATE" : GST_CERTIFICATE,
    "PAN_CARD" : PAN_CARD,
    "COMPANY_CERTIFICATE" : COMPANY_CERTIFICATE,
    "CANCEL_CHEQUE" : CANCEL_CHEQUE,
    "NOT_UPLOADED" : NOT_UPLOADED,
    "SUCCESS" : SUCCESS,
    "GST_PDF" : GST_PDF,
    "CANCEL_CHEQUE_PDF" : CANCEL_CHEQUE_PDF,
    "COMPANY_CERTIFICATE_PDF" : COMPANY_CERTIFICATE_PDF,
    "PAN_PDF" : PAN_PDF,
    "FLOW_FINISHED_STATUS" : FLOW_FINISHED_STATUS,
    "FINISH_BUTTON_NAME" : FINISH_BUTTON_NAME,
    "FOUND_TEXT" : FOUND_TEXT

}

export { labels };

export default class PartnerOnboardingLabelFactory extends LightningElement {}