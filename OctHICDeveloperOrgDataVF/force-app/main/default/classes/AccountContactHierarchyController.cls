public class AccountContactHierarchyController {
    public List<AccountWrapper> accountWrappers { get; private set; }
    
    public AccountContactHierarchyController() {
        loadAccountsWithContacts();
    }
    
    private void loadAccountsWithContacts() {
        List<Account> accounts = [SELECT Id, Name, 
                                  (SELECT Id, FirstName, LastName, Email, Phone 
                                   FROM Contacts 
                                   ORDER BY LastName, FirstName)
                                  FROM Account
                                  ORDER BY Name
                                  LIMIT 100];
        
        accountWrappers = new List<AccountWrapper>();
        for (Account acc : accounts) {
            accountWrappers.add(new AccountWrapper(acc));
        }
    }
    
    public class AccountWrapper {
        public Account account { get; set; }
        public List<Contact> contacts { get; set; }
        
        public AccountWrapper(Account acc) {
            this.account = acc;
            this.contacts = acc.Contacts;
        }
    }
}