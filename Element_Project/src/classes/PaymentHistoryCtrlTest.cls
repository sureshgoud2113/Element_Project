@isTest
private class PaymentHistoryCtrlTest {
	
    @testSetup static void setup() {
        
        Case caseObj = new Case();
        caseObj.Status = 'New';
        caseObj.Origin = 'Email';
        caseObj.Type = 'Other';
        caseObj.Subject = 'Need Assistance on Renewal of Insurance';
        insert caseObj;
        
        Policy__c policyObj = new Policy__c();
        policyObj.Name = 'POLICY123AAB';
        policyObj.Policy_Name__c = 'LIC e term policy';
        policyObj.Plan_Type__c = 'Mid term';
        policyObj.Status__c = 'Active';
        insert policyObj;
        
        Related_Policy__c relatedPolicy = new Related_Policy__c();
        relatedPolicy.Policy__c = policyObj.Id;
        relatedPolicy.Case__c = caseObj.Id;
        insert relatedPolicy;
    }
    
    private static testMethod void getRelatedPoliciesShouldReturnPoliciesRelatedToCase() {
        Case caseObj = [Select Id FROM Case Where Status = 'New' LIMIT 1];
        
        List<Related_Policy__c> relatedPolicies = new List<Related_Policy__c>();
        Test.startTest();
        	relatedPolicies = PaymentHistoryCtrl.getRelatedPolicies(caseObj.Id);
        Test.stopTest();
        
        Related_Policy__c relatedPolicy = [Select Id, Policy__c, Case__c FROM Related_Policy__c WHERE Case__c =: caseObj.Id];
        
        System.assertNotEquals(relatedPolicies, null);
        System.assertEquals(relatedPolicies[0].Id, relatedPolicy.Id);
    }
    
    private static testmethod void getPaymentHistoryShouldGetValidResponseWhenSendingValidHttpRequest() {
        PaymentHistoryMock fakeResponse = new PaymentHistoryMock(200,
                                                               'Complete',
                                                               '[{"Name": "sForceTest1"}]'
                                                               );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        	PaymentHistoryCtrl.getPaymentHistory();
        Test.stopTest();
    }
    
    private static testmethod void getPaymentHistoryShouldGetInvalidResponseWhenSendingInvalidHttpRequest() {
        PaymentHistoryMock fakeResponse = new PaymentHistoryMock(400,
                                                               'Bad Request',
                                                               '[]'
                                                               );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        PaymentHistoryCtrl.getPaymentHistory();
    }
}