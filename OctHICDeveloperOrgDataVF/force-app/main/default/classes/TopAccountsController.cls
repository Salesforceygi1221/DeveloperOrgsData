public class TopAccountsController {
    
    private ApexPages.StandardSetController standardController;
    
    // Constructor
    public TopAccountsController(ApexPages.StandardSetController stdSetController) {
        this.standardController = stdSetController;
    }
    
    public List<Account> getTopAccounts() {
        return [SELECT Name, AnnualRevenue, Industry, Phone 
                FROM Account 
                WHERE AnnualRevenue != null 
                ORDER BY AnnualRevenue DESC 
                LIMIT 10];
    }
}