trigger Tri_Opportunity_Department on Opportunity
(after insert, after update, after delete) {
    new DepartmentOpportunityTriggerHandler().run();
}