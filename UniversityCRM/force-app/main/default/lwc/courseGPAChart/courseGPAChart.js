import { LightningElement, wire } from 'lwc';
import getCourseAverageGrades from '@salesforce/apex/CourseGPAController.getCourseAverageGrades';

export default class CourseGPAChart extends LightningElement {
    chartData = [];
    error;

    @wire(getCourseAverageGrades)
    wiredGrades({ data, error }) {
        if (data) {
            this.chartData = data.map(item => ({
                courseName: item.courseName,
                avgGrade: item.avgGrade.toFixed(2)
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.chartData = [];
        }
    }
}