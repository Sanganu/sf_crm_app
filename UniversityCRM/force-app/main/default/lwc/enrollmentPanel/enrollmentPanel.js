import { LightningElement, wire } from 'lwc';
import getEnrollments from '@salesforce/apex/EnrollmentService.getEnrollments';

export default class EnrollmentPanel extends LightningElement {
    @wire(getEnrollments) enrollments;
}