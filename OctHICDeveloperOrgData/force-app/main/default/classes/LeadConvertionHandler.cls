public class LeadConvertionHandler {
    public class LeadConvertRequest {

        @InvocableVariable(
            label = 'Lead ID'
            description = 'ID of the Lead record.'
            required = true
        )
        public ID leadId;

        @InvocableVariable(
            label = 'Converted Status'
            description = 'Converted Lead Status picklist value.'
            required = true
        )
        public String convertedStatus;      

    }

    
    public class LeadConvertResult {

        @InvocableVariable( label = 'Lead ID' )
        public ID leadId;

        @InvocableVariable( label = 'Account ID' )
        public ID accountId;

        @InvocableVariable( label = 'Contact ID' )
        public ID contactId;

        @InvocableVariable( label = 'Opportunity ID' )
        public ID opportunityId;

    }


    @InvocableMethod(
        label = 'Convert Lead'
        iconName = 'slds:standard:lead_insights'
    )
    public static List<LeadConvertResult> convertLead( List<LeadConvertRequest> requests ) {

        // transform the invocable request to database convert request
        List<Database.LeadConvert> convertRequests = new List<Database.LeadConvert>();
        for ( LeadConvertRequest request : requests ) {
            convertRequests.add( transform( request ) );
        }

        List<Database.LeadConvertResult> convertResults = Database.convertLead( convertRequests, true );

        List<LeadConvertResult> results = new List<LeadConvertResult>();
        for ( Database.LeadConvertResult convertResult : convertResults ) {
            results.add( transform( convertResult ) );
        }

        return results;
    }


    private static Database.LeadConvert transform( LeadConvertRequest request ) {

        Database.LeadConvert convertRequest = new Database.LeadConvert();

        convertRequest.setLeadId( request.leadId );
        convertRequest.setConvertedStatus( request.convertedStatus );

		convertRequest.setSendNotificationEmail(False);
        return convertRequest;
    }

    private static LeadConvertResult transform( Database.LeadConvertResult convertResult ) {

        LeadConvertResult result = new LeadConvertResult();

        result.leadId = convertResult.getLeadId();
        result.accountId = convertResult.getAccountId();
        result.contactId = convertResult.getContactId();
        result.opportunityId = convertResult.getOpportunityId();

        return result;
    }

    public class ConvertLeadException extends Exception {}
    
    /*@InvocableMethod(label='Convert Leads' description='Converts leads to accounts, contacts, and opportunities')
    public static void convertCMLeads(List<Id> leadIds) {
        try{
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            if(convertStatus != null){
                for (Id leadId : leadIds) {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(leadId);
                    lc.setConvertedStatus(convertStatus.MasterLabel); 
                    // Ensure an Opportunity is created during the conversion
                    lc.setDoNotCreateOpportunity(false);
                    leadConverts.add(lc);
                }
            }
            Database.LeadConvertResult[] lcr = Database.convertLead(leadConverts);
        }catch(Exception excep){
            system.debug('Exeption: '+excep.getMessage()+' and Line Number'+excep.getLineNumber());
        }
    }*/
}