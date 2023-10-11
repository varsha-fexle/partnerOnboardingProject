import { LightningElement,api,track } from 'lwc';
import updateFileOnAccount from '@salesforce/apex/PartnerSignupFormController.uploadFileOnAccount';
import { labels } from "c/partnerOnboardingLabelFactory";
import PartnerSignup_staticResource from '@salesforce/resourceUrl/PartnerSignup';


export default class UploadDocuments extends LightningElement {

    @api parent;
    @track fileTitle;
    @track enableDocumentScreen = false;
    @track enblePriContScrn = true;
    @track documentsError = '';
    @track showDocumentsError = false;
    @api receivedValue;
    @api isgstuploaded=false;
    @api ispanuploaded=false;
    @api iscertuploaded = false;
    @api ischequeuploaded = false;
    @api isLoaded = false;
    @track label = labels;

    

    document = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/folder.png';
    uploadPDF = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/pdf.png';
    
    /*Description :- This method is invoked when a file is uploaded.It reads the uploaded file 
                     using a FileReader, extracts its contents as base64-encoded data, and 
                     invokes handleUpload().*/
    handleFileUploaded(event) {
        this.fileTitle = event.target.name;
        if (event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            this.file = this.filesUploaded[0];
             console.log(this.filesUploaded.length);
                if (this.filesUploaded.length > 0) {
                    this.isLoading = true;
                    this.file = this.filesUploaded[0];
                    // create a FileReader object 
                    this.fileReader = new FileReader();
                    // set onload function of FileReader object  
                    this.fileReader.onloadend = (() => {
                        this.fileContents = this.fileReader.result;
                        let base64 = this.label.FILE_FORMAT;
                        this.content = this.fileContents.indexOf(base64) + base64.length;
                        this.fileContents = this.fileContents.substring(this.content);
                        this.handleUpload();
                        
                    });
                    this.fileReader.readAsDataURL(this.file); 
    
                } else {
                    this.isLoading = false;
                }   
        }
    } 

    /*Description :- This method handles the upload of the file to the server. It calls the Apex 
                     method updateFileOnAccount to upload the file and then dispatches a custom 
                     event to notify other components of the upload status.*/
    handleUpload() {
        this.isLoaded = true;
        if(this.fileContents != null && this.fileContents != undefined) {
            updateFileOnAccount ({
                idParent : this.parent,
                strFileName : this.fileName,
                base64Data : this.fileContents,
                fileTitle : this.fileTitle
            }).then(result=>{
                this.isLoaded = false;
                if((this.fileTitle == this.label.GST_PDF && result == this.label.SUCCESS)) {
                    this.isgstuploaded = true;
                    const selectedEvent = new CustomEvent("documentsupload", {
                        detail: {
                            companyDocuments : true,
                            primaryContactInfo: false,
                            isGstUploaded: this.isgstuploaded,
                            isPanUploaded: this.ispanuploaded,
                            isCertUploaded: this.iscertuploaded,
                            isChequeUploaded: this.ischequeuploaded,
                            thankyouScreen: false
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                    
                }
                else if(this.fileTitle == this.label.PAN_PDF && result == this.label.SUCCESS) {
                  
                    this.ispanuploaded = true;
                    const selectedEvent = new CustomEvent("documentsupload", {
                        detail: {
                            companyDocuments : true,
                            primaryContactInfo: false,
                            isGstUploaded: this.isgstuploaded,
                            isPanUploaded: this.ispanuploaded,
                            isCertUploaded: this.iscertuploaded,
                            isChequeUploaded: this.ischequeuploaded,
                            thankyouScreen: false
                        }
                    });
                    this.dispatchEvent(selectedEvent);

                } else if(this.fileTitle == this.label.COMPANY_CERTIFICATE_PDF && result == this.label.SUCCESS) {
                   
                    this.iscertuploaded = true;
                    const selectedEvent = new CustomEvent("documentsupload", {
                        detail: {
                            companyDocuments : true,
                            primaryContactInfo: false,
                            isGstUploaded: this.isgstuploaded,
                            isPanUploaded: this.ispanuploaded,
                            isCertUploaded: this.iscertuploaded,
                            isChequeUploaded: this.ischequeuploaded,
                            thankyouScreen: false
                            
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                   
                } else if(this.fileTitle == this.label.CANCEL_CHEQUE_PDF && result == this.label.SUCCESS) {
                    this.ischequeuploaded = true;
                    const selectedEvent = new CustomEvent("documentsupload", {
                        detail: {
                            companyDocuments: true,
                            primaryContactInfo: false,
                            isGstUploaded: this.isgstuploaded,
                            isPanUploaded: this.ispanuploaded,
                            isCertUploaded: this.iscertuploaded,
                            isChequeUploaded: this.ischequeuploaded,
                            thankyouScreen: false
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }
                
            }).catch(error=>{
                this.documentsError = error;
                this.template.querySelector('c-common-toast').showToast('error','<strong>'+this.documentsError+'<strong/>','utility:error',3000); 
            })
        }  
    }

    /*Description :- This method is triggered when the user submits uploaded documents. If all 
                     documents are uploaded, it displays a success message and triggers a custom 
                     event to transition to the next step. If any document is missing, it displays 
                     an error message indicating which documents are missing.*/
    submitDocuments(event) {
        this.documentsError = '';
        this.showDocumentsError = false;
        this.showDocumentsError = false;
        if(this.isgstuploaded == true && this.ispanuploaded == true && this.iscertuploaded == true && this.ischequeuploaded == true) {
            //this.template.querySelector('c-common-toast').showToast('success','<strong>'+this.label.DOCUMENTS_UPLOADED_SUCCESSFULLY+'<strong/>','utility:success',3000);
            const selectedEvent = new CustomEvent("documentsupload", {
                detail: {
                    companyDocuments : this.enableDocumentScreen,
                    primaryContactInfo: this.enblePriContScrn,
                    isGstUploaded: this.isgstuploaded,
                    isPanUploaded: this.ispanuploaded,
                    isCertUploaded: this.iscertuploaded,
                    isChequeUploaded: this.ischequeuploaded,
                    thankyouScreen: true
                }
            });
            this.dispatchEvent(selectedEvent);   
        } else {
            if(this.isgstuploaded != true) {
                this.documentsError += this.label.GST_CERTIFICATE + ' ,';
            }
            if(this.ispanuploaded != true) {
               this.documentsError += ' '+ this.label.PAN_CARD + ' ,';
            }
            if(this.iscertuploaded != true) {
                this.documentsError += ' ' + this.label.COMPANY_CERTIFICATE +' ,';
            }
            if(this.ischequeuploaded != true) {
                this.documentsError += ' ' + this.label.CANCEL_CHEQUE +' ,';
            }
            this.documentsError = this.documentsError.substring(0,this.documentsError.length-1);
            this.documentsError+= ' ' + this.label.NOT_UPLOADED;
            this.template.querySelector('c-common-toast').showToast('error','<strong>'+this.documentsError+'<strong/>','utility:error',3000); 
        }
    }

    /* Description :- This method is invoked when the user clicks the back button. It dispatches an
                      event to notify other components to navigate to the previous screen.*/
    handleClickOnBackButton(event) {
        let companyInfoScreen = true;
        const selectedEvent = new CustomEvent("previousscreen", {
            detail: {
                companyDocuments : false,
                companyInfo : companyInfoScreen
            }
        });
        this.dispatchEvent(selectedEvent);
    }
}