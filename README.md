# Element_Project
Element Use case Project

Use case: Send Email to Approved Customers

   1. Considered Contact object as Customers.
   2. Created Batch class & schedule class to send email to customers Whose claim status is Approved.
    
       Batch Apex: SendEmailToApprovedCustomer_Batch
       
       Schedule Apex: SendEmailToApprovedCustomer_Schedule
       
   3. We can configure to schedule this job to run daily at 12 AM. Then Batch apex picks all Yesterday's approved customers         and send email accordingly.
   4. Created Error Log object and ExceptionHandler class to debug the errors and it's logging.
   5. Created Email template to send email to customers
       Email template name: ClaimApprovedEmailNotificationTemplate.email
       
Use Case: Create lightning Component to display on case record page

   1. Created new custom object to store all policies information.
   2. Created another custom Object Related Policy. It is related to Case & Policy. It acts as Junction object to Case & 
      Policy and customer related policies will display under the Case.
   3. Created lightning component and displayed Related Policies information and Payment History.
   
      Lightining Component: CasePaymetHistory.cmp,
                            CasePaymetHistoryController.js,
                            CasePaymetHistoryHelper.js
                            
      Apex Class: PaymentHistoryCtrl.cls
      
   4. In the Above Lightning component, It has 2 sections. Related Policies and Payment History.
   5. Payment History displays the data from REST Integration. Based on the Endpoint, It fetches the JSON response and  
      displays the same in the component.
      
      EndPoint URL:               https://gist.githubusercontent.com/sureshgoud2113/b7c7cce700a5acd25df0d902ca66381d/raw/b237f01c17ff3ac52fb43bc0a0e9bd1ff7b19279/paymentHistory.json

   6. It also Shown Last Sync date.
