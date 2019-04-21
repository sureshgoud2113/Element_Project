({
	init : function(component, event, helper) {
        
        // Get Related Policies
        component.set('v.relatedPolicyColumns', [
            {label: 'Policy Id', fieldName: 'linkName', type: 'url',
            	typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
            },
            {label: 'Policy Name', fieldName: 'Policy_Name__c',type: 'text'}
        ]);
        helper.getRelatedPoliciesHelper(component);
        
        // Get Payment Histories
        component.set('v.paymentHistoryColumns', [
            {label: 'Payment Date', fieldName: 'paymentDate', type: 'date',
             typeAttributes:{
                year: "numeric",
                month: "long",
                day: "2-digit"
                }
            },
            {label: 'Account Number', fieldName: 'encryptedAccNumber', type: 'text',
             typeAttributes: {label: { fieldName: 'AccountNumber' }}},
            {label: 'Amount', fieldName: 'amount',type: 'currency'},
            {label: 'Payment Brought Into Salesforce', fieldName: 'broughtInSFDC', type:'date',
            	typeAttributes:{
                    year: "numeric",
                    month: "long",
                    day: "2-digit"
                }
            }
          ]);
		helper.getPaymentHistoryHelper(component);
                
    }
})