import {LightningElement,wire} from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getCourses from '@salesforce/apex/CourseService.getCourses';

const COLUMNS = [
    {label:'Course Name',fieldName:'Course_Name__c',sortable:true},
    {label:'Course Code',fieldName:'Code__c',sortable:true},
    {label:'Course End Date',fieldName:'Course_End_Date__c',sortable:false},
    {label:'Course Start Date',fieldName:'Course_Start_Date__c',sortable:true},
    {label:'Credits',fieldName:'Credits__c',sortable:false},
    {label:'Semester',fieldName:'Semester__c',sortable:true},
    {label:'Total students enrolled',fieldName:'Total_students_enrolled__c'},
    {label:'Capacity',fieldName:'Max_Capacity__c',sortable:true},
    {
        type:'action',
        typeAttributes: {
            rowActions:[
                {label:'View Details',name:'view'},
                {label:'Enroll',name:'enroll'}
            ]
        }
    }
];


export default class CourseList extends LightningElement{
    courses;
    error;
    isLoading = true;
    columns = COLUMNS;

    _wiredCoursesResult;

    @wire(getCourses)
    wiredCourses(result){
        
    }
}