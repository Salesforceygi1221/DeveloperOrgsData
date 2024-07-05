public class AccountTypeChartController {
    public String selectedType { get; set; }
    
    public List<SelectOption> getAccountTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'All Types'));
        
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry entry : ple) {
            options.add(new SelectOption(entry.getValue(), entry.getLabel()));
        }
        return options;
    }
    
    @RemoteAction
    public static Map<String, Integer> getAccountCounts(String selectedType) {
        Map<String, Integer> result = new Map<String, Integer>();
        
        String query = 'SELECT Type, COUNT(Id) count FROM Account';
        if (String.isNotBlank(selectedType)) {
            query += ' WHERE Type = :selectedType';
        }
        query += ' GROUP BY Type';
        
        for (AggregateResult ar : Database.query(query)) {
            String type = (String)ar.get('Type');
            Integer count = (Integer)ar.get('count');
            result.put(type != null ? type : 'No Type', count);
        }
        
        return result;
    }
}