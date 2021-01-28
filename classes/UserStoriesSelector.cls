public with sharing class UserStoriesSelector extends fflib_SObjectSelector {
    private static final String INDEXING_ENABLED = 'Stop_Indexing_Metadata__c = false AND Project__r.Index_Metadata__c = true';
    public List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{ User_Story__c.Id };
    }

    public SObjectType getSObjectType() {
        return User_Story__c.sObjectType;
    }

    public Database.QueryLocator byIdWithIndexingEnabled(Set<Id> ids) {
        return Database.getQueryLocator(newQueryFactory().setEnforceFLS(true).setCondition('Id IN :ids AND ' + INDEXING_ENABLED).toSOQL());
    }

    public Database.QueryLocator withIndexingEnabled() {
        return Database.getQueryLocator(newQueryFactory().setEnforceFLS(true).setCondition(INDEXING_ENABLED).toSOQL());
    }
}