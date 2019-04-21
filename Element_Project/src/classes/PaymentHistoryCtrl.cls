public class PaymentHistoryCtrl {
    
    @AuraEnabled
    public static string getPaymentHistory(){
        HttpResponse response = new HttpResponse ();
         try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(System.Label.ENDPOINT_URL);
            req.setMethod('GET');
            
            // Send HTTP Request to get Payment histories 
            response = h.send(req);
            if(response.getStatusCode()==200){
               return response.getBody();
            }
            return null;
        }
        catch(exception e){
            String responseError = 'StatusCode: '+ String.valueOf(response.getStatusCode()) + 'Response Body: '+ response.getBody();
            ExceptionHandler.logApexCalloutError('PaymentHistoryCtrl','getPaymentHistory',string.valueOf(e.getLineNumber()), responseError);
        }
        return null;
    }
    
    @AuraEnabled
    public static List<Related_Policy__c > getRelatedPolicies(Id caseId){
        try{
    		return [SELECT Id, Name, Case__c, Policy__c, Policy_Name__c FROM Related_Policy__c Where Case__c =: caseId];
        }
        catch(StringException e){
            ExceptionHandler.logApexCalloutError('PaymentHistoryCtrl','getRelatedPolicies',string.valueOf(e.getLineNumber()), e.getMessage());
        }
        catch(QueryException qe){
            ExceptionHandler.logApexCalloutError('PaymentHistoryCtrl','getRelatedPolicies',string.valueOf(qe.getLineNumber()), qe.getMessage());
        }
        return null;
    }

}