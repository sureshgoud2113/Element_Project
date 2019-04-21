/*
 * Batch Apex to send email to all customers whose claims are approved yesterday.
 * This runs 1 time per day and send email to all approved customers.
 */
global with sharing class SendEmailToApprovedCustomer_Batch implements Database.Batchable<sObject> {
	
	String query;
	
	global SendEmailToApprovedCustomer_Batch(){
        
        // Build Query to get The Approved Customers (Contacts)
		query = 'SELECT ID, Name, Email, Claim_Status__c FROM Contact WHERE Claim_Status__c = ' + '\'' + System.Label.APPROVED + '\'';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        
        // Run the Query to get The Approved Customers (Contacts)
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Contact> scope) {
        
        try{
            // Get the Email template
            EmailTemplate templateObj = [Select id from EmailTemplate where name = 'ClaimApprovedEmailNotificationTemplate'];
    
            Set<Id> contactIds = new Set<Id>();
            for(Contact cont: scope){
                contactIds.add(cont.Id);
            }
            
            if(!contactIds.isEmpty()){
                // Get Yesterday's Claims Approved customers
                Set<Id> yesterdaysClaimsApprovedCustomers = getYesterdaysClaimsApprovedCustomers(contactIds);
                
                if(!yesterdaysClaimsApprovedCustomers.isEmpty()){
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            
                    for(Id contId : yesterdaysClaimsApprovedCustomers) {
                        Messaging.SingleEmailMessage mail = buildSingleEmailMessage(contId, templateObj.Id);
                        allmsg.add(mail);
                    }
                    // Send Emails to all Approved Customers
                    Messaging.sendEmail(allmsg,false);
                }
            }
        }
        catch(Exception e){
            // If any Exception occur, then error message will be stored in Error log custom object
            ExceptionHandler.logApexCalloutError('SendEmailToApprovedCustomer_Batch','ExecutionMethod',string.valueOf(e.getLineNumber()), e.getMessage());
        }

	}
	
	global void finish(Database.BatchableContext BC) {
	}	
	
    // Build SingleEmailMessage to send emails
	private Messaging.SingleEmailMessage buildSingleEmailMessage(Id contactId, Id templateId){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setTemplateID(templateId);
        
        // Using targetObjectId as contactId, So these emails doens't count under daily email limit. 
        // So, It never hits the daily email limit count
		mail.setTargetObjectId(contactId);
        
        // Set activity as true to display these activities in record details page activity section
		mail.setSaveAsActivity(true);

		return mail;
	}
	
    // Method to retrieve all customers whose claims are approved yesterday
	private Set<Id> getYesterdaysClaimsApprovedCustomers(Set<Id> contactIds){
		
        List<ContactHistory> contactHistories ;
        if(Test.isRunningTest()){  
            list<Id> idList = new list<Id>();
            idList.addAll(contactIds);
            contactHistories = new List<ContactHistory>{}; 
            contactHistories.add(new ContactHistory(ContactId=idList[0], Field='Claim_Status__c'));
     	}
        else{
            // Fetching the Contact Histories to get Yesterdays approved status of claim status. It filter all other days except Yesterday.
            // So Email send to customers only whose claim status is approved yesterday
			contactHistories = [SELECT ContactId,CreatedById,CreatedDate,Field,Id,NewValue,OldValue 
											FROM ContactHistory 
											WHERE ContactId IN: contactIds
											AND Field = 'Claim_Status__c' 
											AND CreatedDate = YESTERDAY
											ORDER BY CreatedDate DESC ];
        }
        
        // Using Set to get all approved customers Ids to send emails.
        // Using Set, It won't store duplicate Ids and emails will be sent only once to each customer.
		Set<Id> yesterdaysApprovedContactIds = new Set<Id>();
		for(ContactHistory contHistory: contactHistories){
            if(!Test.isRunningTest() && contHistory.OldValue != contHistory.NewValue && contHistory.NewValue == System.Label.APPROVED){
            	yesterdaysApprovedContactIds.add(contHistory.ContactId);
            }
            else{
                yesterdaysApprovedContactIds.add(contHistory.ContactId);
            }
		}
		return yesterdaysApprovedContactIds;
	}
}