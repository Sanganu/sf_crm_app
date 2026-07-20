public with sharing class DepartmentOpportunityTriggerHandler extends TriggerHandler {

    protected override void afterInsert() {
        recalcOpenPositions(collectAccountIds((List<Opportunity>) Trigger.new, null));
    }

    protected override void afterUpdate() {
        recalcOpenPositions(collectAccountIds(
            (List<Opportunity>) Trigger.new,
            (Map<Id, Opportunity>) Trigger.oldMap
        ));
    }

    protected override void afterDelete() {
        recalcOpenPositions(collectAccountIds((List<Opportunity>) Trigger.old, null));
    }

    private static Set<Id> collectAccountIds(
        List<Opportunity> recs,
        Map<Id, Opportunity> oldMap
    ) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity o : recs) {
            if (o.AccountId != null) accountIds.add(o.AccountId);
            if (oldMap != null) {
                Opportunity old = oldMap.get(o.Id);
                if (old != null && old.AccountId != null) accountIds.add(old.AccountId);
            }
        }
        return accountIds;
    }

    private static void recalcOpenPositions(Set<Id> accountIds) {
        if (accountIds.isEmpty()) return;

        Map<Id, Decimal> openCountByAccount = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT AccountId acc, SUM(Head_Count__c) total
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND IsClosed = false
            GROUP BY AccountId
        ]) {
            openCountByAccount.put((Id) ar.get('acc'), (Decimal) ar.get('total'));
        }

        List<Account> toUpdate = new List<Account>();
        for (Id accId : accountIds) {
            toUpdate.add(new Account(
                Id = accId,
                Open_Position__c = openCountByAccount.containsKey(accId)
                    ? openCountByAccount.get(accId)
                    : 0
            ));
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}