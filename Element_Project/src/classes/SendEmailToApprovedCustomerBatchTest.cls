@isTest
private class SendEmailToApprovedCustomerBatchTest {

	@testSetup static void setup() {
        // Create common test Contacts
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<2;i++) {
            testContacts.add(new Contact(LastName = 'TestContact'+i, Claim_Status__c = 'Submitted'));
        }
        insert testContacts;        

        for(Contact c: testContacts){
        	Datetime yesterday = Datetime.now().addDays(-1);
			Test.setCreatedDate(c.Id, yesterday);
        }
    }

    private static testmethod void sendEmailToApprovedCustomerBatchShouldSendEmailToCustomersWhenClaimsAreApproved() {
        list<Contact> contactListToUpdate = new list<Contact>();
        for(Contact cont: [SELECT Id, Claim_Status__c, CreatedDate FROM Contact WHERE Claim_Status__c='Submitted' ]){
        	cont.Claim_Status__c = System.Label.APPROVED;
        	contactListToUpdate.add(cont);
        }
        update contactListToUpdate;
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>(contactListToUpdate);
        List<Id> contactIds = new List<Id>(contactMap.keySet());

		Test.startTest();
			SendEmailToApprovedCustomer_Batch batchToExecute = new SendEmailToApprovedCustomer_Batch();
			Database.executeBatch(batchToExecute);
		Test.stopTest();

		list<Contact> contactList = [SELECT (SELECT ActivityDate, Description, Subject from ActivityHistories) FROM Contact WHERE Id IN: contactIds];
		
        for(Contact cont: contactList){
            for(ActivityHistory contActivityHistory: cont.ActivityHistories){
                System.assertNotEquals(contActivityHistory, null);
                System.assertEquals(contActivityHistory.Subject, 'Claim Approval Notification');
                System.assertEquals(contActivityHistory.ActivityDate, Datetime.now().addDays(-1));
                System.assertEquals(contActivityHistory.ActivityType, 'Contact');
            }
        }
    }
    
    private static testmethod void sendEmailToApprovedCustomerBatchShouldNotSendEmailToCustomersWhenClaimsAreNotApproved() {
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Claim_Status__c, CreatedDate FROM Contact WHERE Claim_Status__c='Submitted']);
        List<Id> contactIds = new List<Id>(contactMap.keySet());
        
		Test.startTest();
			SendEmailToApprovedCustomer_Batch batchToExecute = new SendEmailToApprovedCustomer_Batch();
			Database.executeBatch(batchToExecute);
		Test.stopTest();

		list<Contact> contactList = [SELECT (SELECT ActivityDate, Description, Subject from ActivityHistories) FROM Contact WHERE Id IN: contactIds];
		
        for(Contact cont: contactList){
            for(ActivityHistory contActivityHistory: cont.ActivityHistories){
                System.assertEquals(contActivityHistory, null);
            }
        }
    }

}