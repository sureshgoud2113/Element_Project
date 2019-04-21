public class ExceptionHandler {
    public static void logApexCalloutError(String className,String methodName,String lineno,String errorMsg) {
        Error_Log__c log = new Error_Log__c();
        log.Class_Name__c = className;
        log.Method_Name__c = methodName;
        log.Line_Number__c = lineno;
        log.log_time__c=System.now();
        log.user__c = UserInfo.getUserId();
        
        // You can get HTTP Status Code and Response Body
        if(errorMsg!=null)
        {
            log.Error_Description__c=errorMsg;
        }
        insert log;     
    }  
}