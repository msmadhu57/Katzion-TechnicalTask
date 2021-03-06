/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   TransactionItems Trigger Handler to send the all the Transaction Items related to a transaction when all transaction items that are part of the same transaction are found in SF
* Created Date    :--   19th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/
public class TransactionItemTriggerHandler {
    public static boolean firstRun = true;
    // Sends the set of TransactionIDs which are the parents of the newly added TransactionItems once all the Transaction Items are found
    public static void sendDataToCallout(list < TransactionItem__c > tItemsList) {
        Set < Id > transIds = new set < Id > ();
        List < TransactionItem__c > allTItemsList = new List < TransactionItem__c > ();
        List < Transaction__c > allTransList = new List < Transaction__c > ();
        Map < Id, List < TransactionItem__c >> transMap = new Map < Id, List < TransactionItem__c >> ();
        Set < Id > final_transIds = new Set < Id > ();
        for (TransactionItem__c tItem: tItemsList) {
            // Adds all the TransactionIDs to a set
            transIds.add(tItem.Transaction__c);
        }
        // Adds all the Transaction Items which are the child records for the TransactionIDs
        allTItemsList = [SELECT Id, Name, Item_Cost__c, Transaction__c
            FROM TransactionItem__c
            WHERE Transaction__c IN: transIds
        ];
        // Adds all the Transaction Data from TransactionsIDs
        allTransList = [SELECT Id, Name, Total_Cost__c, Total_Discount__c, Transaction_Count__c
            FROM Transaction__c
            WHERE Id IN: transIds
        ];
        // Map to hold the TransactionID and Transaction Items as Key-Value pairs
        for (TransactionItem__c tI: allTItemsList) {
            if (!transMap.containsKey(tI.Transaction__c))
                transMap.put(tI.Transaction__c, new List < TransactionItem__c > {
                    tI
                });
            else
                transMap.get(tI.Transaction__c).add(tI);
        }
        for (Transaction__c t: allTransList) {
            // Checks if all the Transaction Items are found for a particular Transaction and adds TransactionIDs to a set.
            if (transMap.get(t.Id).size() == t.Transaction_Count__c) {
                final_transIds.add(t.Id);
            }
        }
        if (final_transIds != null && !final_transIds.isEmpty()) {
            // Passing TransactionIDs to make Callout
            SendHttpCallout.makeCallout(final_transIds);
        }
    }
}
