import {LightningElement,api} from 'lwc';

export default class Studentcard extends LightningElement{
    @api student;

    handleEnrollClick(){
        this.dispatchEvent(
            new CustomEvent('enroll',{
                detail:{studentId:this.student.Id}
            })
        )
    }
}