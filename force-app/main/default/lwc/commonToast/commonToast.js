import { LightningElement,track,api} from 'lwc';

export default class CommonToast extends LightningElement {

    @track type='success';
    @track message;
    @track messageIsHtml=false;
    @track showToastBar = false;
    @api autoCloseTime = 5000;
    @track icon='';
    
    // Public method to show the toast with specified parameters
    @api
    showToast(type, message,icon,time) {
        this.type = type;
        this.message = message;
        this.icon=icon;
        this.autoCloseTime=time;
        this.showToastBar = true;
        // Automatically close the toast after the specified time interval
        setTimeout(() => {
            this.closeModel();
        }, this.autoCloseTime);
    }
    
    // Closes the toast and clears its properties
    closeModel() {
        this.showToastBar = false;
        this.type = '';
        this.message = '';
    }
 
    // Returns the icon name to be displayed in the toast
    get getIconName() {
        if(this.icon)
        {
            return this.icon;
        }
        return 'utility:' + this.type;
    }
 
    // Returns the class for the icon container
    get innerClass() {
        return 'slds-icon_container slds-icon-utility-' + this.type + ' slds-m-right_small slds-no-flex slds-align-top';
    }
 
    // Returns the class for the outer toast container
    get outerClass() {
        return 'slds-notify slds-notify_toast slds-theme_' + this.type;
    }
}