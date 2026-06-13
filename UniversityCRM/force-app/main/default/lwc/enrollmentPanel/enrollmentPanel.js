import { LightningElement, wire } from 'lwc';
import getEnrollments from '@salesforce/apex/EnrollmentService.getEnrollments';

export default class EnrollmentPanel extends LightningElement {
    @api recordId;
    wiredResult;
    enrollments = [];
    error;

    @wire(getEnrollmentForStudents,{ studentId: '$recordId' })
    wired(result){
        this.wiredResult = result;
        if(result.data){this.enrollments = result.data; this.error = undefined;}
        else if(result.error){ this.error = result.error; this.enrollments=[]}
    }

    handleRefresh(){
        return refreshApex(this.wiredResult);
    }
}