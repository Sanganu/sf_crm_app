import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

const CHANNEL = '/event/Enrollment_Change__e';

const COLUMNS = [
    {label:'Change type',fieldName:'changeType', type:'text'},
    {label:'New Status',fieldName:'newStatus', type:'text'},
    {label:'Enrollment Id',fieldName:'enrollmentId', type:'text'},
    {label:'Student Id',fieldName:'studentId', type:'text'},
    {label:'Time',fieldName:'timeStamp', type:'text'},
]

export default class EnrollmentLiveFeed extends LightningElement {
    subscription;
    events = [];
    columns = COLUMNS;

    connectedCallback() {
        this.registerErrorListener();
        this.handleSubscribe();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    handleSubscribe() {
        const callback = (message) => {
            const payload = message.data.payload;
            this.events = [
                {
                    id: message.data.event.replayId,
                    enrollmentId: payload.Enrollment_Id__c,
                    studentId: payload.Student_Id__c,
                    changeType: payload.Change_Type__c,
                    newStatus: payload.New_Status__c,
                    transactionId: payload.Transaction_Id__c,
                    timestamp: new Date().toLocaleTimeString()
                },
                ...this.events
            ].slice(0, 10); // keep only the 10 most recent
        };

        subscribe(CHANNEL, -1, callback).then((response) => {
            this.subscription = response;
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription);
    }

    registerErrorListener() {
        onError((error) => {
            console.error('EMP API error:', JSON.stringify(error));
        });
    }
}