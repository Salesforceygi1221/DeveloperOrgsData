public with sharing class DownloadRecordsController {
    @AuraEnabled(cacheable=true)
    public static List<Lead> getData(List<String> ids) {
        if (ids != null) {
            List<Lead> listLead = [
                SELECT Id, FirstName, LastName, Email, Company, City, State, LeadSource
                FROM Lead
                WHERE Id IN :ids
            ];
            return listLead;
        } else {
            return null;
        }
    }
}