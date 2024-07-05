public class ContactSearchController {
    public String searchTerm { get; set; }
    public List<Contact> searchResults { get; private set; }
    
    public ContactSearchController() {
        searchResults = new List<Contact>();
    }
    
    public void performSearch() {
        if (String.isNotBlank(searchTerm)) {
            String likeTermName = '%' + searchTerm + '%';
            searchResults = [SELECT Id, FirstName, LastName, Email, Phone 
                             FROM Contact 
                             WHERE Name LIKE :likeTermName 
                             ORDER BY LastName, FirstName 
                             LIMIT 100];
        } else {
            searchResults.clear();
        }
    }
    
    public Boolean getHasResults() {
        return !searchResults.isEmpty();
    }
}