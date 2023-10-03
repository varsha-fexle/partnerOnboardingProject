import { LightningElement, track,api } from 'lwc';
import createPersonAccount from '@salesforce/apex/PartnerSignupFormController.createPersonAccount';
import { labels } from "c/partnerOnboardingLabelFactory";
import getCompanies from '@salesforce/apex/PartnerSignupFormController.getAccount';
import createContact from '@salesforce/apex/PartnerSignupFormController.createContact';
import createCompanyAccount from '@salesforce/apex/PartnerSignupFormController.createCompanyAccount';
import fetchContact from '@salesforce/apex/PartnerSignupFormController.fetchContact';
import { loadStyle } from 'lightning/platformResourceLoader';
import PartnerSignup_staticResource from '@salesforce/resourceUrl/PartnerSignup';

export default class PartnerSignupForm extends LightningElement {

    fiveStepGraphic = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/five_step_graphic.png';
    profile = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/profile.png';
    invoice = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/invoice.png';
    bank = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/bank.png';
    company = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/company.png';
    search = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/search.png';
    resource = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/resource.png';
    thankyou = PartnerSignup_staticResource + '/PartnerSignup_staticResource/Images/thankyou.png';

    @track options = [];
    @track personalInfo = false;
    @track initialScreen = true;
    @track selectedPartnerType;
    @track disableNextButton = true;
    @track contactObj = {};
    @track accountObj = {};
    @track copyAccountObj={};
    @track searchScreen = false;
    @track isPersonalInfoCompleted = true;
    @track accountNameTrimed;
    @track accountWebsiteTrimed;
    @track isValidContact = true;
    @track companyInfo = false;
    @track isValidCompany = true;
    @track companyDocuments = false;
    @track partnerId='';
    @track contactInfo =false;
    @track isValidPartnerContact = true;
    @track instruction = true;
    @api isLoaded = false;
    @track searchCompanyName;
    @track searchCompanyWebsite;
    @track thankyouScreen = false;
    @track renderFlow = false;
    @track isGstUploaded=false;
    @track isPanUploaded=false;
    @track isCertUploaded = false;
    @track isChequeUploaded = false;
    @track genderOptions = [];
    @track accountExists = false;
    @track label = labels;
    @track disabled = false;
    inputVariables = [];
     
    /*Description :- This method is called when the component is connected to the DOM.
                     It's used here to load styles and initialize arrays for partner 
                     types and gender options.*/
    connectedCallback() {
        loadStyle(this, PartnerSignup_staticResource + '/PartnerSignup_staticResource/PartnerSignup-css.css');
        let partnerTypes = [];
            partnerTypes.push({label: this.label.INDIVIDUAL_PARTNER_LABEL , value: this.label.INDIVIDUAL_PARTNER_VALUE});
            partnerTypes.push({label: this.label.PARTNER_LABEL, value: this.label.PARTNER_VALUE});
            partnerTypes.push({label: this.label.SEARCH_COMPANY_LABEL, value: this.label.SEARCH_COMPANY_VALUE});
        this.options = partnerTypes;
        let genderTypes = [];
            genderTypes.push({label: 'Male' , value: 'Male'});
            genderTypes.push({label: 'Female', value: 'Female'});
            genderTypes.push({label: 'Other', value: 'Other'});
        this.genderOptions = genderTypes;  
    }

    /*Description :- This method is triggered when the partner type selection changes. 
                     It updates the selected partner type and enables the "Next" button.*/
    handleChange(event) {
        this.disabled = false;
        this.accountObj = {};
        this.selectedPartnerType = event.detail.value;
        if(event.detail.value != null) {
            this.disableNextButton = false;
        }
    }

    /*Description :- This method handles the logic for proceeding to the next screen based 
                     on the selected partner type. It sets flags to show different sections 
                     of the form.*/
    handleNextOfInitialScreen(event) {
        this.accountObj = {};
        this.contactObj = {};
        this.disabled = false;
        this.isCertUploaded = false;
        this.isChequeUploaded = false;
        this.isGstUploaded = false;
        this.isPanUploaded = false;
        this.copyAccountObj = {};
        if(this.selectedPartnerType == this.label.INDIVIDUAL_PARTNER_VALUE) {
            this.personalInfo = true;
            this.initialScreen = false;
        }
        else if(this.selectedPartnerType == this.label.SEARCH_COMPANY_VALUE) {
            this.initialScreen = false;
            this.searchScreen = true;
            this.searchCompanyWebsite = '';
            this.searchCompanyName = '';
        }
        else if(this.selectedPartnerType == this.label.PARTNER_VALUE) {
            this.initialScreen = false;
            this.companyInfo = true;
            this.accountObj = {};
        }
    }

    /*Description :- This method is used to handle input changes from various input fields in 
                     the form. It updates the corresponding properties accordingly.*/
    handleInputChange(event) {
        if(event.target.name == 'accFirstname') {
            this.accountObj.firstName = event.detail.value;
        } else if(event.target.name == 'accLastname') {
            this.accountObj.lastName = event.detail.value;
        } else if(event.target.name == 'accEmail') {
            this.accountObj.email = event.detail.value;
        } else if(event.target.name == 'accMobNum') {
            this.accountObj.mobileNumber = event.detail.value;
        } else if(event.target.name == 'accAadhar') {
            this.accountObj.aadharCard = event.detail.value;
            if(this.accountObj.aadharCard.length == 4 || this.accountObj.aadharCard.length == 9) {
                this.accountObj.aadharCard = this.accountObj.aadharCard + ' ';
            }
        } else if(event.target.name == 'accPancard') {
            this.accountObj.panCardNumber = event.detail.value;
        } else if(event.target.name == 'accBillingStreet') {
            this.accountObj.accountBillingStreet = event.detail.value;
        } else if(event.target.name == 'accBillingCity') {
            this.accountObj.accountBillingCity = event.detail.value;
        } else if(event.target.name == 'accBillingState') {
            this.accountObj.accountBillingState = event.detail.value;
        } else if(event.target.name == 'accBillingPostalCode') {
            this.accountObj.accountBillingPostalCode = event.detail.value;
        } else if(event.target.name == 'accBillingCountry') {
            this.accountObj.accountBillingCountry = event.detail.value; 
        } else if(event.target.name == 'accHolderName') {
            this.accountObj.accountHolderName = event.detail.value;
        } else if(event.target.name == 'accBankName') {
            this.accountObj.bankName = event.detail.value;
        } else if(event.target.name == 'accBankBranchAdd') {
            this.accountObj.brachAddress = event.detail.value;
        } else if(event.target.name == 'accBankAccNum') {
            this.accountObj.accountNumber = event.detail.value;
        } else if(event.target.name == 'accIfscCode') {
            this.accountObj.ifscCode = event.detail.value;
        } else if(event.target.name == 'conFirstName') {
            this.contactObj.firstName = event.detail.value;
        } else if(event.target.name == 'conEmail') {
            this.contactObj.email = event.detail.value;
        } else if(event.target.name == 'conMobNum') {
            this.contactObj.mobileNumber = event.detail.value;
        } else if(event.target.name == 'conLastName') {
            this.contactObj.lastName = event.detail.value;
        } else if(event.target.name == 'conAadhar') {
            this.contactObj.aadharCard = event.detail.value;
            if(this.contactObj.aadharCard.length == 4 || this.contactObj.aadharCard.length == 9) {
                this.contactObj.aadharCard = this.contactObj.aadharCard + ' ';
            }
        } else if(event.target.name == 'conPancard') {
            this.contactObj.panCardNumber = event.detail.value;
        } else if(event.target.name == 'companyName') {
            this.accountObj.accountName = event.detail.value;
        } else if(event.target.name == 'companyWebsite') {
            this.accountObj.website = event.detail.value;
        } else if(event.target.name == 'comGstNumber') {
            this.accountObj.gstNumber = event.detail.value;
        } else if(event.target.name == 'comPanNumber') {
            this.accountObj.companyPANNumber = event.detail.value;
        } else if(event.target.name == 'companyStreet') {
            this.accountObj.accountBillingStreet = event.detail.value;
        } else if(event.target.name == 'companyCity') {
            this.accountObj.accountBillingCity = event.detail.value;
        } else if(event.target.name == 'companyState') {
            this.accountObj.accountBillingState = event.detail.value;
        } else if(event.target.name == 'companyPostalCode') {
            this.accountObj.accountBillingPostalCode = event.detail.value;
        } else if(event.target.name == 'companyCountry') {
            this.accountObj.accountBillingCountry = event.detail.value;
        } else if(event.target.name == 'comAccHoldName') {
            this.accountObj.accountHolderName = event.detail.value;
        } else if(event.target.name == 'comBankName') {
            this.accountObj.bankName = event.detail.value;
        } else if(event.target.name == 'comBankBranAdd') {
            this.accountObj.brachAddress = event.detail.value;
        } else if(event.target.name == 'comBankAccNum') {
            this.accountObj.accountNumber = event.detail.value;
        } else if(event.target.name == 'comIfscCode') {
            this.accountObj.ifscCode = event.detail.value;
        } else if(event.target.name == 'searchCompanyName') {
            this.searchCompanyName = event.detail.value;
        } else if(event.target.name == 'searchCompanyWebsite'){
            this.searchCompanyWebsite = event.detail.value;
        } else if(event.target.name == 'primaryContact') {
            this.contactObj.isPrimaryContact = event.target.checked;
        }
    }

    /* Description :- This method is used to create a person account. It performs form validation
                      and then calls an Apex method to create the account. If successful, it 
                      updates the UI accordingly.*/
    createPersonAccount(event) {
        this.isPersonalInfoCompleted = true;
        let firstName = this.template.querySelector('.firstName');
        let firstNameVal = firstName.value;
        firstNameVal = firstNameVal.trim();
        if(!firstNameVal) {
          firstName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
          this.isPersonalInfoCompleted = false;
        } else {
          firstName.setCustomValidity('');
        }
        firstName.reportValidity();
        let lastName = this.template.querySelector('.lastName');
        let lastNameVal = lastName.value;
        lastNameVal = lastNameVal.trim();
        if(!lastNameVal) {
          lastName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
          this.isPersonalInfoCompleted = false;
        } else {
          lastName.setCustomValidity('');
        }
        lastName.reportValidity();
        let mobileNumber = this.template.querySelector('.mobileNumber');
        let mobileNumberVal = mobileNumber.value;
        if(!mobileNumberVal) {
           mobileNumber.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
           this.isPersonalInfoCompleted = false;
        } else {
           mobileNumber.setCustomValidity('');
        }
        mobileNumber.reportValidity();
        let email = this.template.querySelector('.email');
        let emailVal = email.value;
        const pat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        emailVal = emailVal.trim();
        if(!emailVal) {
            email.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else if(!pat.test(emailVal)) {
            email.setCustomValidity(INVALID_EMAIL);
            this.isPersonalInfoCompleted = false;
        } else {
            email.setCustomValidity('');
        }
        email.reportValidity();
        let aadharCard = this.template.querySelector('.aadharCard');
        let aadharCardVal = aadharCard.value;
        aadharCardVal = aadharCardVal.trim();
        if(!aadharCardVal) {
            aadharCard.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else if(aadharCardVal.length < 14) {
            aadharCard.setCustomValidity(this.label.INVALID_AADHAR_CARD_NUMBER);
            this.isPersonalInfoCompleted = false;
        } else if(aadharCardVal.charAt(0) == '0' || aadharCardVal.charAt(0) == '1') {
            aadharCard.setCustomValidity(this.label.FIRST_DIGIT_OF_AADHAR_CARD_NUM_ERROR);
            this.isPersonalInfoCompleted = false;
        }
        else {
            aadharCard.setCustomValidity('');
        }
        aadharCard.reportValidity();
        let panCard = this.template.querySelector('.panCard');
        let panCardVal = panCard.value;
        panCardVal = panCardVal.trim();
        if(!panCardVal) {
            panCard.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else { 
            panCard.setCustomValidity('');   
        }
        panCard.reportValidity();
        let street = this.template.querySelector('.street');
        let streetVal = street.value;
        streetVal = streetVal.trim();
        if(!streetVal) {
            street.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            street.setCustomValidity('');
        }
        street.reportValidity();
        let city = this.template.querySelector('.city');
        let cityVal = city.value;
        cityVal = cityVal.trim();
        if(!cityVal) {
            city.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            city.setCustomValidity('');
        }
        city.reportValidity();
        let state = this.template.querySelector('.state');
        let stateVal = state.value;
        stateVal = stateVal.trim();
        if(!stateVal) {
            state.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            state.setCustomValidity('');
        }
        state.reportValidity();
        let postalCode = this.template.querySelector('.postalCode');
        let postalCodeVal = postalCode.value;
        postalCodeVal = postalCodeVal.trim();
        if(!postalCodeVal) {
            postalCode.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            postalCode.setCustomValidity('');
        }
        postalCode.reportValidity();
        let country = this.template.querySelector('.country');
        let countryVal = country.value;
        countryVal = countryVal.trim();
        if(!countryVal) {
            country.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            country.setCustomValidity('');
        }
        country.reportValidity();
        let accHolderName = this.template.querySelector('.accHolderName');
        let accHolderNameVal = accHolderName.value;
        accHolderNameVal = accHolderNameVal.trim();
        if(!accHolderNameVal) {
            accHolderName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            accHolderName.setCustomValidity('');
        }
        accHolderName.reportValidity();
        let bankName = this.template.querySelector('.bankName');
        let bankNameVal = bankName.value;
        bankNameVal = bankNameVal.trim();
        if(!bankNameVal) {
            bankName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            bankName.setCustomValidity('');
        }
        bankName.reportValidity();
        let bankBranchAdd = this.template.querySelector('.bankBranchAdd');
        let bankBranchAddVal = bankBranchAdd.value;
        bankBranchAddVal = bankBranchAddVal.trim();
        if(!bankBranchAddVal) {
            bankBranchAdd.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            bankBranchAdd.setCustomValidity('');
        }
        bankBranchAdd.reportValidity();
        let bankAccNum = this.template.querySelector('.bankAccNum');
        let bankAccNumVal = bankAccNum.value;
        bankAccNumVal = bankBranchAddVal.trim();
        if(!bankAccNumVal) {
            bankAccNum.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            bankAccNum.setCustomValidity('');
        }
        bankAccNum.reportValidity();
        let ifscCode = this.template.querySelector('.ifscCode');
        let ifscCodeVal = ifscCode.value;
        ifscCodeVal = ifscCodeVal.trim();
        if(!ifscCodeVal) {
            ifscCode.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isPersonalInfoCompleted = false;
        } else {
            ifscCode.setCustomValidity('');
        }
        ifscCode.reportValidity();
        if(panCard.checkValidity() == false || aadharCard.checkValidity() == false || email.checkValidity() == false || mobileNumber.checkValidity() == false ) {
            this.isPersonalInfoCompleted = false;
        }
        if(this.isPersonalInfoCompleted == true) {
            createPersonAccount({
                accountInfoJSON : JSON.stringify(this.accountObj)
            }).then(result=>{
                if(result.length == this.label.REC_ID_LEN) {
                    this.template.querySelector('c-common-toast').showToast('success','<strong>'+this.label.PERSON_ACCOUNT_IS_CREATED+'<strong/>','utility:success',3000);
                    this.instruction = false;
                    this.personalInfo = false;
                    this.accountObj.accountId = result;
                    this.thankyouScreen = true;
                    this.renderFlow = this.thankyouScreen;
                    let fullName = this.accountObj.firstName + ' ' + this.accountObj.lastName;
                    this.inputVariables = [
                        {
                            name: 'varT_AccountName',
                            type: 'String',
                            value: fullName
                        },
                        {
                            name: 'varB_AlreadyExists',
                            type: 'Boolean',
                            value: this.accountExists
                        },
                        {
                            name: 'varT_AccountId',
                            type: 'String',
                            value: this.accountObj.accountId
                        }
                    ]  
                } else {
                    this.template.querySelector('c-common-toast').showToast('error','<strong>'+result+'<strong/>','utility:error',3000);
                }
            }).catch(error=>{
                this.template.querySelector('c-common-toast').showToast('error','<strong>'+error+'<strong/>','utility:error',3000);
                
            })
        }  
    }

    /*Description :- This method is used to navigate back to the initial screen of the form.*/
    redirectedToInitialScreen(event) {
        this.personalInfo = false;
        this.searchScreen = false;
        this.companyInfo = false;
        this.initialScreen = true;
        this.instruction = true;
    }

    /*Description :- This method handles the company search functionality. It calls an Apex 
                     method to fetch company information based on the provided search criteria.*/
    companySearch(event) {
        this.isLoaded = true;
        if(this.searchCompanyName == undefined || this.searchCompanyName == null) {
            this.accountNameTrimed = '';
        } else {
            this.accountNameTrimed = this.searchCompanyName;
            this.accountNameTrimed = this.accountNameTrimed.trim();
        }
        if(this.accountNameTrimed.length == 0) {
            this.searchCompanyName = null;
        }
        if(this.searchCompanyWebsite == undefined || this.searchCompanyWebsite == null) {
            this.accountWebsiteTrimed = '';
        } else {
            this.accountWebsiteTrimed= this.searchCompanyWebsite.trim();
        }
        if(this.accountWebsiteTrimed.length == 0) {
            this.searchCompanyWebsite = null;
        }
        if(this.accountNameTrimed.length != 0 || this.accountWebsiteTrimed.length != 0) { 
                getCompanies({
                    accountName : this.searchCompanyName,
                    accountWebsite: this.searchCompanyWebsite
                }).then(result=>{
                    this.isLoaded = false;
                    if(result != null && result != undefined) {
                        if(result.length == this.label.REC_ID_LEN) {
                            this.partnerId = result.accountId;
                            this.accountObj.accountId = result.accountId;
                            this.searchScreen = false;
                            this.contactInfo = true;
                        } else {
                            this.template.querySelector('c-common-toast').showToast('error','<strong>'+result+'<strong/>','utility:error',2000);
                        }
                    }
                    else {
                        this.template.querySelector('c-common-toast').showToast('error','<strong>'+this.label.NOT_FOUND+'<strong/>','utility:warning',5000);   
                    }
                }).catch(error=>{
                        this.isLoaded = false;
                        this.template.querySelector('c-common-toast').showToast('error','<strong>'+error+'<strong/>','utility:error',5000);     
                }) 
        }
        else {
            this.template.querySelector('c-common-toast').showToast('error','<strong>'+this.label.ONE_VALUE_REQUIRE+'<strong/>','utility:error',2000);       
            this.isLoaded = false;
        }
    }

    /*Description :- This method is responsible for validating and saving company information.*/
    saveCompanyInformation(event) {
            this.isValidCompany = true;
            let firstName = this.template.querySelector('.companyName');
            let firstNameVal = firstName.value;
            firstNameVal = firstNameVal.trim();
            if(!firstNameVal) {
              firstName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
              this.isValidCompany = false;
            } else {
              firstName.setCustomValidity('');
            }
            firstName.reportValidity();
            let website = this.template.querySelector('.companyWebsite');
            let websiteVal = website.value;
            const webPat = /(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})(\.[a-zA-Z0-9]{2,})?/
            websiteVal = websiteVal.trim();
            if(!websiteVal) {
              website.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
              this.isValidCompany = false;
            } else if(!webPat.test(websiteVal)) {
              website.setCustomValidity(this.label.INVALID_WEBSITE);
              this.isValidCompany = false;
            }
            else {
              website.setCustomValidity('');
            }
            website.reportValidity();
            let gstNumber = this.template.querySelector('.comGstNumber');
            let gstNumberVal = gstNumber.value;
            gstNumberVal = gstNumberVal.trim();
            if(!gstNumberVal) {
               gstNumber.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
               this.isValidCompany = false;
            } else {
               gstNumber.setCustomValidity('');
            }
            gstNumber.reportValidity();
            let panNumber = this.template.querySelector('.comPanNumber');
            let panNumberVal = panNumber.value;
            panNumberVal = panNumberVal.trim();
            if(!panNumberVal) {
                panNumber.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                panNumber.setCustomValidity('');
            }
            panNumber.reportValidity();
            let street = this.template.querySelector('.companyStreet');
            let streetVal = street.value;
            streetVal = streetVal.trim();
            if(!streetVal) {
                street.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                street.setCustomValidity('');
            }
            street.reportValidity();
            let city = this.template.querySelector('.companyCity');
            let cityVal = city.value;
            cityVal = cityVal.trim();
            if(!cityVal) {
                city.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                city.setCustomValidity('');
            }
            city.reportValidity();
            let state = this.template.querySelector('.companyState');
            let stateVal = state.value;
            stateVal = stateVal.trim();
            if(!stateVal) {
                state.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                state.setCustomValidity('');
            }
            state.reportValidity();
            let postalCode = this.template.querySelector('.companyPostalCode');
            let postalCodeVal = postalCode.value;
            postalCodeVal = postalCodeVal.trim();
            if(!postalCodeVal) {
                postalCode.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                postalCode.setCustomValidity('');
            }
            postalCode.reportValidity();
            let country = this.template.querySelector('.companyCountry');
            let countryVal = country.value;
            countryVal = countryVal.trim();
            if(!countryVal) {
                country.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                country.setCustomValidity('');
            }
            country.reportValidity();
            let accHolderName = this.template.querySelector('.comAccHoldName');
            let accHolderNameVal = accHolderName.value;
            accHolderNameVal = accHolderNameVal.trim();
            if(!accHolderNameVal) {
                accHolderName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                accHolderName.setCustomValidity('');
            }
            accHolderName.reportValidity();
            let bankName = this.template.querySelector('.comBankName');
            let bankNameVal = bankName.value;
            bankNameVal = bankNameVal.trim();
            if(!bankNameVal) {
                bankName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                bankName.setCustomValidity('');
            }
            bankName.reportValidity();
            let bankBranchAdd = this.template.querySelector('.comBankBranAdd');
            let bankBranchAddVal = bankBranchAdd.value;
            bankBranchAddVal = bankBranchAddVal.trim();
            if(!bankBranchAddVal) {
                bankBranchAdd.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                bankBranchAdd.setCustomValidity('');
            }
            bankBranchAdd.reportValidity();
            let bankAccNum = this.template.querySelector('.comBankAccNum');
            let bankAccNumVal = bankAccNum.value;
            bankAccNumVal = bankAccNumVal.trim();
            if(!bankAccNumVal) {
                bankAccNum.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                bankAccNum.setCustomValidity('');
            }
            bankAccNum.reportValidity();
            let ifscCode = this.template.querySelector('.comIfscCode');
            let ifscCodeVal = ifscCode.value;
            ifscCodeVal = ifscCodeVal.trim();
            if(!ifscCodeVal) {
                ifscCode.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
                this.isValidCompany = false;
            } else {
                ifscCode.setCustomValidity('');
            }
            ifscCode.reportValidity();
            if(panNumber.checkValidity() == false || gstNumber.checkValidity() == false) {
                this.isValidCompany = false;
            }
            if(website.checkValidity() == false) {
                this.isValidCompany = false;
            }
            if(this.isValidCompany == true) {
                this.isLoaded = true;
                if(JSON.stringify(this.accountObj) != JSON.stringify(this.copyAccountObj)) {
                    createCompanyAccount({
                        accountInfoJSON : JSON.stringify(this.accountObj)
                    }).then(result=>{
                        if(result != null) {
                            this.isLoaded = false;
                            if(result.length == this.label.REC_ID_LEN) {
                                if(this.accountObj.accountId != null && this.accountObj.accountId != undefined && this.accountObj.accountId != '') {
                                    this.template.querySelector('c-common-toast').showToast('success','<strong>'+this.label.ACCOUNT_IS_UPDATED+'<strong/>','utility:success',1000);
                                }
                                else{
                                    this.template.querySelector('c-common-toast').showToast('success','<strong>'+this.label.ACCOUNT_IS_CREATED+'<strong/>','utility:success',1000);    
                                }
                                this.partnerId = result;
                                this.accountObj.accountId = result;
                                this.disabled = true;
                                this.copyAccountObj = {...this.copyAccountObj,...this.accountObj};
                                this.companyInfo = false;
                                this.instruction = false;
                                this.companyDocuments = true;
                            }
                            else {
                                this.template.querySelector('c-common-toast').showToast('error','<strong>'+result+'<strong/>','utility:error',2000);
                            }
                        }
                        else {
                            this.isLoaded = false;
                            this.template.querySelector('c-common-toast').showToast('error','<strong>Error<strong/>','utility:error',2000);
                        }
                        
                    }).catch((error) => {
                        this.isLoaded = false;
                        this.template.querySelector('c-common-toast').showToast('error','<strong>'+error+'<strong/>','utility:error',2000);
                    });
                }
                else {
                    this.isLoaded = false;
                    this.partnerId = this.accountObj.accountId;
                    this.companyInfo = false;
                    this.instruction = false;
                    this.companyDocuments = true;
                }
            }
    }

    /*Description :- This method is used to save contact information associated with a company.*/
    saveContactInformation(event) {
        if(this.selectedPartnerType == this.label.SEARCH_COMPANY_VALUE) {
                this.accountExists = true;
            }
            this.inputVariables = [
                {
                    name: 'varT_AccountName',
                    type: 'String',
                    value: this.accountObj.accountName
                },
                {
                        name: 'varB_AlreadyExists',
                        type: 'Boolean',
                        value: this.accountExists
                },
                {
                        name: 'varT_AccountId',
                        type: 'String',
                        value: this.accountObj.accountId
                }
            ] 
        let buttonName = event.target.name;
        this.contactObj.accountId = this.partnerId;
        this.isValidPartnerContact = true;
        let firstName = this.template.querySelector('.conFirstName');
        let firstNameVal = firstName.value;
        firstNameVal = firstNameVal.trim();
        if(!firstNameVal){
          firstName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
          this.isValidPartnerContact = false;
        } else {
          firstName.setCustomValidity('');
        }
        firstName.reportValidity();
        let lastName = this.template.querySelector('.conLastName');
        let lastNameVal = lastName.value;
        lastNameVal = lastNameVal.trim();
        if(!lastNameVal){
          lastName.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
          this.isValidPartnerContact = false;
        } else {
          lastName.setCustomValidity('');
        }
        lastName.reportValidity();
        let mobileNumber = this.template.querySelector('.conMobNum');
        let mobileNumberVal = mobileNumber.value;
        mobileNumberVal = mobileNumberVal.trim();
        if(!mobileNumberVal){
           mobileNumber.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
           this.isValidPartnerContact = false;
        } else {
           mobileNumber.setCustomValidity('');
        }
        mobileNumber.reportValidity();
        let email = this.template.querySelector('.conEmail');
        let emailVal = email.value;
        const pat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        emailVal = emailVal.trim();
        if(!emailVal) {
            email.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isValidPartnerContact = false;
        } else if(!pat.test(emailVal)) {
            email.setCustomValidity(this.label.INVALID_EMAIL);
            this.isValidPartnerContact = false;
        } else {
            email.setCustomValidity('');
        }
        email.reportValidity();
        let panCard = this.template.querySelector('.conPancard');
        let panCardVal = panCard.value;
        panCardVal = panCardVal.trim();
        if(!panCardVal){
            panCard.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isValidPartnerContact = false;
        } else { 
            panCard.setCustomValidity('');
        }
        panCard.reportValidity();
        let aadharCard = this.template.querySelector('.conAadhar');
        let aadharCardVal = aadharCard.value;
        aadharCardVal = aadharCardVal.trim();
        if(!aadharCardVal) {
            aadharCard.setCustomValidity(this.label.REQUIRED_FIELD_ERROR);
            this.isValidPartnerContact = false;
        } else if(aadharCardVal.length < 14) {
            aadharCard.setCustomValidity(this.label.INVALID_AADHAR_CARD_NUMBER);
            this.isValidPartnerContact = false;
        } else if(aadharCardVal.charAt(0) == '0' || aadharCardVal.charAt(0) == '1') {
            aadharCard.setCustomValidity(this.label.FIRST_DIGIT_OF_AADHAR_CARD_NUM_ERROR);
            this.isValidPartnerContact = false;
        } else { 
            aadharCard.setCustomValidity('');
        }
        aadharCard.reportValidity();
        if(panCard.checkValidity() == false || aadharCard.checkValidity() == false || email.checkValidity() == false || mobileNumber.checkValidity() == false) {
            this.isValidPartnerContact = false;
        }
        if(this.isValidPartnerContact == true) {
            if(this.contactObj.isPrimaryContact == null || this.contactObj.isPrimaryContact == undefined || this.contactObj.isPrimaryContact == '') {
                this.contactObj.isPrimaryContact = false;
            }
              fetchContact({
                email : this.contactObj.email,
                accountId : this.accountObj.accountId
            }).then(result=>{
                if(result == this.label.FOUND_TEXT) {
                   this.template.querySelector('c-common-toast').showToast('error','<strong>'+this.label.RESOURCE_ALREADY_EXISTS+'<strong/>','utility:error',2000);
                }
                else {
                     createContact({
                        contactInfoJSON : JSON.stringify(this.contactObj)
                    }).then(result =>{
                        if(result.length == this.label.REC_ID_LEN) {
                            if(buttonName == this.label.FINISH_BUTTON_NAME) {
                                this.contactInfo = false;
                                this.instruction = false;
                                this.thankyouScreen = true;
                                this.renderFlow = true;
                            } else {
                                this.contactObj = {};
                                this.contactObj.isPrimaryContact = false;
                            }
                            this.template.querySelector('c-common-toast').showToast('success','<strong>'+this.label.CONTACT_IS_CREATED+'<strong/>','utility:success',2000);
                        } else { 
                            this.template.querySelector('c-common-toast').showToast('error','<strong>'+result+'<strong/>','utility:error',2000);    
                        }
                    }).catch(error=>{

                        this.template.querySelector('c-common-toast').showToast('error','<strong>'+error+'<strong/>','utility:error',2000);
                        
                    })
                }
            });
        }
    }

    /*Description :- This method handles the document upload process.*/
    handleDocumentsUpload(event) {
        this.companyDocuments = event.detail.companyDocuments;
        this.contactInfo = event.detail.primaryContactInfo;
        
        this.isGstUploaded = event.detail.isGstUploaded;
        this.isPanUploaded = event.detail.isPanUploaded;
        this.isChequeUploaded = event.detail.isChequeUploaded;
        this.isCertUploaded = event.detail.isCertUploaded;
        if(this.isGstUploaded == true && this.isPanUploaded == true && this.isChequeUploaded == true && this.isCertUploaded && this.companyDocuments == false) {
            this.contactObj.isPrimaryContact = true;
            this.instruction = true;
        }
    }

    /*Description :- This method is triggered when the user navigates back to the search 
                      screen. It updates the screen transition flags accordingly.*/
    redirectedToSearchScreen(event) {
        this.companyInfo = false;
        this.searchScreen = true;
    }

    /*Description :- This method handles the back button functionality when viewing uploaded 
                      documents. It updates the status of screens and flags to revert to a 
                      previous state.*/
    handleBackOfUploadedDocuments(event) {
        this.companyDocuments = event.detail.documents;
        this.companyInfo = event.detail.companyInfo;
        this.instruction = true;

    }

    /*Description :- This method handles the back button functionality when viewing contact 
                     information. It updates screen transition flags based on the partner 
                     type.*/
    handleBackOfContactInfoScreen(event) {
        if(this.selectedPartnerType == this.label.PARTNER_VALUE) {
            this.contactInfo = false;
            this.instruction = false;
            this.companyDocuments = true;   
        } else {
            this.contactInfo = false;
            this.searchScreen = true;
        }
    }
    
    /*Description :- This method listens for status changes in the flow and hides the flow when 
                    the status indicates that the flow has finished.*/
    handleStatusChange(event) {
        if (event.detail.status === this.label.FLOW_FINISHED_STATUS) {
            //Hide the Flow again
            this.renderFlow = false;
        }
    }
}