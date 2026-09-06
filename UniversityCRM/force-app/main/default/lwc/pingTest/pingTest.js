import { LightningElement } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';

export default class PingTest extends LightningElement {
    messages = [];

    connectedCallback() {
        onError((err) => console.log('🐛 PING onError:', JSON.stringify(err)));

        subscribe('/event/Ping_Test__e', -1, (msg) => {
            console.log('✅ PING RECEIVED:', JSON.stringify(msg));
            this.messages = [msg.data.payload.Message__c, ...this.messages];
        }).then((resp) => {
            console.log('✅ PING SUBSCRIBE SUCCESS:', JSON.stringify(resp));
        }).catch((err) => {
            console.log('🐛 PING SUBSCRIBE FAILED:', JSON.stringify(err));
        });
    }
}