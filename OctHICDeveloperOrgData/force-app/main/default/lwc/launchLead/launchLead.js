import { LightningElement, api, track } from 'lwc';

    export default class FlowCaller extends LightningElement {
        @api flowInputVariables = {};
        @track showFlow = false;

        handleClick() {
            this.showFlow = true;
        }

        handleStatusChange(event) {
            if (event.detail.status === 'FINISHED') {
                // Handle the finish event
            }
        }

        handleFinish(event) {
            // Handle the finish event
        }
    }