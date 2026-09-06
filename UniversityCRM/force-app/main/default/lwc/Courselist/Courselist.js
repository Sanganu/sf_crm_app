import {LightningElement,wire} from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getCourses from '@salesforce/apex/CourseController.getCourses';

const COLUMNS = [
    {label:'Course Name',fieldName:'Name__c',sortable:true},
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
    error;
    isLoading = true;
    columns = COLUMNS;
    
    courses;
    wiredCoursesResult;

    @wire(getCourses)
    wiredCourses(result){
        this.wiredCoursesResult =result;
        this.isLoading = false;
        const { data,error} = result;
        if(data){
            this.courses = data;
            this.error = undefined;
        }else if(error){
            this.error = error.body?.message || error.message || 'Unable to load coourse...Try again'
            this.courses = undefined;
            console.error('Error loading courses',error);
        }
    }
        //similar to useEffect 
        connectedCallback(){
            console.log('Courselist component mounted');
        }
        //useEffect cleanup
        disconnectedCallback(){
            console.log('CourseList unmounted');
        }

        //Errorhandling - similar to React error Boundary
        errorCallback(error,stack){
            this.error = `Child component error: ${error.message}`;
            console.error(`LWC Error Boundary caught:`,error.message);
            console.error('Stack:',stack);
        }

        get hasCourses(){
            return Array.isArray(this.courses) && this.courses.length > 0;
        }
       
        get isEmpty(){
            return !this.isLoading && !this.error && !this.hasCourses;
        }

        get enrolledCount(){
            if(!this.courses) return 0;
            return this.courses.filter( c=>c.Max_Capacity__c > 0).length;
        }

        handleRetry(){
            this.isLoading = true;
            this.error = undefined;
            refreshApex(this. wiredCoursesResult);
        }

        handleRowAction(event){
            const actionName = event.detail.action.name;
            const row= event.detail.row;
        
            if(actionName === 'enroll'){
                this.dispatchEvent(
                    new CustomEvent('enrollcourse',{
                        detail:{courseId : row.Id,
                            courseName:row.Name
                        },
                        bubbles:true,
                        composed:false
                    })
                );
            }
            if(actionName==='view'){
                this.dispatchEvent(
                    new CustomEvent('viewcourse',{
                        detail:{courseId : row.Id}
                    })
                );
            }
        }
}