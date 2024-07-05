public class CaseListEditController {
    public List<CaseWrapper> caseWrappers { get; set; }
    
    public CaseListEditController() {
        loadCases();
    }
    
    private void loadCases() {
        List<Case> cases = [SELECT Id, CaseNumber, Subject, Status, Priority 
                            FROM Case 
                            ORDER BY CaseNumber DESC 
                            LIMIT 100];
        
        caseWrappers = new List<CaseWrapper>();
        for (Case c : cases) {
            caseWrappers.add(new CaseWrapper(c));
        }
    }
    
    public List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : ple) {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getPriorityOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Priority.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : ple) {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }
    
    public PageReference saveChanges() {
        List<Case> casesToUpdate = new List<Case>();
        for (CaseWrapper cw : caseWrappers) {
            if (cw.isModified) {
                casesToUpdate.add(cw.caseRecord);
            }
        }
        
        try {
            update casesToUpdate;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Cases updated successfully.'));
            loadCases(); // Refresh the list
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error updating cases: ' + e.getMessage()));
        }
        
        return null;
    }
    
    public class CaseWrapper {
        public Case caseRecord { get; set; }
        public Boolean isModified { get; set; }
        
        public CaseWrapper(Case c) {
            this.caseRecord = c;
            this.isModified = false;
        }
    }
}