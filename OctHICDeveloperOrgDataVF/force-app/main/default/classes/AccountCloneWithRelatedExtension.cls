public class AccountCloneWithRelatedExtension {
    private final Account account;
    
    public AccountCloneWithRelatedExtension(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
    }
    
    public PageReference cloneWithRelated() {
        Savepoint sp = Database.setSavepoint();
        try {
            // Clone the Account
            Account clonedAccount = account.clone(false, true, false, false);
            clonedAccount.Name = account.Name + ' - Cloned';
            insert clonedAccount;
            
            // Query for related Contacts
            List<Contact> relatedContacts = [SELECT FirstName, LastName, Email, Phone 
                                             FROM Contact 
                                             WHERE AccountId = :account.Id];
            
            // Clone related Contacts
            List<Contact> clonedContacts = new List<Contact>();
            for (Contact c : relatedContacts) {
                Contact clonedContact = c.clone(false, true, false, false);
                clonedContact.AccountId = clonedAccount.Id;
                clonedContacts.add(clonedContact);
            }
            insert clonedContacts;
            
            // Redirect to the cloned Account's detail page
            return new PageReference('/' + clonedAccount.Id);
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error cloning Account: ' + e.getMessage()));
            return null;
        }
    }
}