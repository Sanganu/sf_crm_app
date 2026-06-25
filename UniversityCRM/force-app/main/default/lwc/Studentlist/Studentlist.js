import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getStudents from '@salesforce/apex/StudentController.getStudents';

export default class StudentList extends LightningElement {
    students;
    wiredStudentsResult;

    @wire(getStudents)
    wiredStudents(result) {
        this.wiredStudentsResult = result;
        const { data, error } = result;
        if (data) {
            this.students = data;
        } else if (error) {
            this.students = undefined;
            console.error('Error loading students', error);
        }
    }

    handleEnroll(event) {
        // Bubbles up the studentId from the child card component.
        // Hook this up to an EnrollmentService Apex call when ready.
        const studentId = event.detail.studentId;
        console.log('Enroll requested for student:', studentId);
    }

    handleRefresh() {
        refreshApex(this.wiredStudentsResult);
    }
}