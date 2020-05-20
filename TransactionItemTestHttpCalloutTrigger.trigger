/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   TransactionItems Trigger to send the all the Transaction Items related to a transaction when all transaction items that are part of the same transaction are found in SF
* Created Date    :--   19th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/
trigger TransactionItemTestHttpCalloutTrigger on TransactionItem__c(after insert) {
    // Bypass trigger using custom settings
    if (!(TriggerExecutionControl__c.getInstance().Skip_TransactionItemTrigger__c)) {
        // Avoids Trigger getting in to recursive loop
        if (trigger.isAfter && TransactionItemTriggerHandler.firstRun) {
            TransactionItemTriggerHandler.firstRun = false;
            if (trigger.isInsert) {
                // Sends the list of recently added Transaction Items from After Insert Trigger
                TransactionItemTriggerHandler.sendDataToCallout(Trigger.New);
            }
        }
    }
}