public class LeadMassUpdateController {
    public List<LeadWrapper> leadWrappers { get; set; }
    public Id newOwnerId { get; set; }
    
    public LeadMassUpdateController() {
        loadLeads();
    }
    
    private void loadLeads() {
        leadWrappers = new List<LeadWrapper>();
        for (Lead lead : [SELECT Id, Name, Company, Email, Owner.Name FROM Lead LIMIT 1000]) {
            leadWrappers.add(new LeadWrapper(lead));
        }
    }
    
    public List<SelectOption> getUsers() {
        List<SelectOption> options = new List<SelectOption>();
        for (User u : [SELECT Id, Name FROM User WHERE IsActive = true ORDER BY Name]) {
            options.add(new SelectOption(u.Id, u.Name));
        }
        return options;
    }
    
    public void updateLeadOwners() {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (LeadWrapper wrapper : leadWrappers) {
            if (wrapper.isSelected) {
                wrapper.lead.OwnerId = newOwnerId;
                leadsToUpdate.add(wrapper.lead);
            }
        }
        
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, leadsToUpdate.size() + ' Leads updated successfully.'));
                loadLeads(); // Refresh the list
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error updating Leads: ' + e.getMessage()));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Leads selected for update.'));
        }
    }
    
    public class LeadWrapper {
        public Lead lead { get; set; }
        public Boolean isSelected { get; set; }
        
        public LeadWrapper(Lead lead) {
            this.lead = lead;
            this.isSelected = false;
        }
    }
}