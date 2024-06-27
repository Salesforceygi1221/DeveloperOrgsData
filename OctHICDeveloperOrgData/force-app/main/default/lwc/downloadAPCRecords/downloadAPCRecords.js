import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getData from '@salesforce/apex/DownloadRecordsController.getData';

export default class DownloadAPCRecords extends NavigationMixin(LightningElement) {
    @api ids;
    splitIds = [];

    connectedCallback() {
        for (var i = 0; i < this.ids.length; i += 18) {
            this.splitIds.push(this.ids.substring(i, i + 18));
        }

        console.log('ids: ', this.ids);
        console.log('splitsIds: ', this.splitIds);

        // Call the Apex method and pass the splitIds array
        getData({ ids: this.splitIds })
            .then(result => {
                console.log('Result: ', result);
                if(result != null){
                    this.downloadCSV(result); // Call the download function with the result
                }
                else{
                    alert(`You have No Select Any Records of Rows`)
                }
            })
            .catch(error => {
                console.error('Error: ', error);
            });
    }

    finishFlow() {
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
    }
    // Function to download data to a CSV
    downloadCSV(data) {
        let csvContent = "data:text/csv;charset=utf-8,";

        // headers
        csvContent += ["Id", "FirstName", "LastName", "Email", "Company", "City", "State", "LeadSource"].join(",") + "\n";

        // data rows
        data.forEach(item => {
            csvContent += [item.Id, item.FirstName, item.LastName, item.Email, item.Company, item.City, item.State, item.LeadSource].join(",") + "\n";
        });

        // Create a blob and download
        let encodedUri = encodeURI(csvContent);
        let link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", "my_data.csv");
        document.body.appendChild(link); // Required for FF
        link.click(); // This will download the data file named "my_data.csv".

        this.finishFlow();
    }
}