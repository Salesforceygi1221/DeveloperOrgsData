public class ContactCreationController {
    public Contact newContact { get; set; }
    public List<SelectOption> accountOptions { get; set; }
    public Id selectedAccountId { get; set; }
    
    public ContactCreationController() {
        newContact = new Contact();
        loadAccountOptions();
    }
    
    private void loadAccountOptions() {
        accountOptions = new List<SelectOption>();
        accountOptions.add(new SelectOption('', '-- Select an Account --'));
        for (Account acc : [SELECT Id, Name FROM Account ORDER BY Name LIMIT 1000]) {
            accountOptions.add(new SelectOption(acc.Id, acc.Name));
        }
    }
    
    public PageReference saveContact() {
        try {
            if (selectedAccountId != null) {
                newContact.AccountId = selectedAccountId;
            }
            insert newContact;
            PageReference contactPage = new PageReference('/' + newContact.Id);
            contactPage.setRedirect(true);
            return contactPage;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating contact: ' + e.getMessage()));
            return null;
        }
    }
}