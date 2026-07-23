import { LightningElement, api } from 'lwc';

export default class RoleBasedRecordView extends LightningElement {
    @api recordId;
    @api viewType; // 'Dean' or 'Student'

    get isDean() {
        return this.viewType === 'Dean';
    }

    get isStudent() {
        return this.viewType === 'Student';
    }
}