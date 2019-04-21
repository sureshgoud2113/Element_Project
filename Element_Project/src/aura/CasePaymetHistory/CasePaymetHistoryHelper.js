({
	getPaymentHistoryHelper: function(component) {
		var paymentHistoryAction = component.get('c.getPaymentHistory'); 
       
        paymentHistoryAction.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var data = JSON.parse(response.getReturnValue()).paymentHistory;
                var caseRelatedPayments = [];
                data.forEach(function(item){
                    item.encryptedAccNumber = '********' + item.AccountNumber.substring(Math.max(item.AccountNumber.length - 3, 0));
                    if(item.caseId==component.get('v.recordId')){
  						caseRelatedPayments.push(item);
                    }
				});
                var today = new Date();
                var monthDigit = today.getMonth() + 1;
                if (monthDigit <= 9) {
                    monthDigit = '0' + monthDigit;
                }
                component.set('v.lastSyncDate', today.getDate() + "-" + monthDigit + "-" + today.getFullYear());
                
                component.set('v.paymentHistoryData',caseRelatedPayments);
                component.set('v.paymentHistoriesLength',caseRelatedPayments.length);
            }
        });
        $A.enqueueAction(paymentHistoryAction);       
	},
    
    getRelatedPoliciesHelper: function(component){
    	var relatedPoliciesAction = component.get('c.getRelatedPolicies');
        var caseId = component.get('v.recordId');
        relatedPoliciesAction.setParams({ "caseId" : caseId });
        
        relatedPoliciesAction.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                response.getReturnValue().forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set('v.relatedPolicyData', response.getReturnValue());
                component.set('v.relatedPoliciesLength', response.getReturnValue().length);
            }
        });
        $A.enqueueAction(relatedPoliciesAction);
	}
})