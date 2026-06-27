import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getStudents from '@salesforce/apex/StudentController.getStudents';
// import ENROLL_STUDENT_CHANNEL from '@salesforce/messageChannel/EnrollStudent__c';
import ENROLL_STUDENT_CHANNEL from '@salesforce/messageChannel/EnrollStudent__c';

export default class StudentList extends LightningElement {
    students;
    wiredStudentsResult;

    @wire(getStudents)
    wiredStudents(result) {
        this.wiredStudentsResult = result;
        const { data, error } = result;
        if (data) {
            this.students = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || error.message || 'Error loading students list...';
            this.students = undefined;
            console.error('Error loading students', error);
        }
    }

    handleEnroll(event) {
        // Bubbles up the studentId from the child card component.
        // Hook this up to an EnrollmentService Apex call when ready.
        const studentId = event.detail.studentId;
        console.log('Enroll requested for student:', studentId);
        publish(this.messageContext, ENROLL_STUDENT_CHANNEL, { studentId });
    }

    handleRefresh() {
        refreshApex(this.wiredStudentsResult);
    }
}