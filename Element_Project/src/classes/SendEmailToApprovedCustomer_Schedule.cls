/*
 * Schedule Apex to run the Batch Job to send email to all customers whose claims are approved yesterday.
 * This runs 1 time per day and send email to all approved customers.
 * As per Schdule, This runs everyday at 12 AM
 */
global class SendEmailToApprovedCustomer_Schedule implements Schedulable{

   global void execute(SchedulableContext sc) {
      SendEmailToApprovedCustomer_Batch batchToExecute = new SendEmailToApprovedCustomer_Batch(); 
      database.executebatch(batchToExecute);
   }
}