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

   1. 
