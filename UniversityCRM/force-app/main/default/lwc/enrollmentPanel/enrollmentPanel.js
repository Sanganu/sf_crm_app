import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext} from 'lightning/messageService'
import getEnrollmentsByStudent from '@salesforce/apex/EnrollmentService.getEnrollmentsByStudent';
import ENROLL_STUDENT_CHANNEL from '@salesforce/messageChannel/EnrollStudent__c';

export default class EnrollmentPanel extends LightningElement {
    selectedStudentId;
    enrollments = [];
    error;
    subscription = null;
    @wire(MessageContext) messageContext;

    connectedCallback(){
        this.subscription = subscribe(
            this.messageContext,
            ENROLL_STUDENT_CHANNEL,
            (message) => this.handleStudentSelected(message)
        );
    }

    handleStudentSelected(message){
        this.selectedStudentId = message.studentId;
    }

    @wire(getEnrollmentsByStudent,{studentId: '$selectedStudentId'})
    wiredEnrollments({data,error}){
        if (data){
            this.enrollments = data;
            this.error = undefined;
        }else if(error){
            this.error = 'Error loading enrollments';
            this.enrollments = []
        }
    }
}