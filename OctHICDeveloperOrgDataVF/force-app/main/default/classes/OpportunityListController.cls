public class OpportunityListController {
    private Integer pageSize = 10;
    public List<Opportunity> opportunities { get; private set; }
    public Integer totalRecords { get; private set; }
    public Integer pageNumber { get; set; }

    public OpportunityListController() {
        pageNumber = 1;
        updateOpportunities();
    }

    public void updateOpportunities() {
        Integer offset = (pageNumber - 1) * pageSize;
        
        opportunities = [SELECT Name, Amount, CloseDate 
                         FROM Opportunity 
                         ORDER BY Name 
                         LIMIT :pageSize 
                         OFFSET :offset];
        
        totalRecords = [SELECT COUNT() FROM Opportunity];
    }

    public PageReference previousPage() {
        if (getHasPrevious()) {
            pageNumber--;
            updateOpportunities();
        }
        return null;
    }

    public PageReference nextPage() {
        if (getHasNext()) {
            pageNumber++;
            updateOpportunities();
        }
        return null;
    }

    public Boolean getHasPrevious() {
        return pageNumber > 1;
    }

    public Boolean getHasNext() {
        Integer totalPages = getTotalPages();
        return pageNumber < totalPages;
    }

    public Integer getTotalPages() {
        return (totalRecords + pageSize - 1) / pageSize;
    }
}