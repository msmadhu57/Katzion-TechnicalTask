/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   This Class is created to make the asynchronous callout for sending TransactionItems, if the response is successful then the parentTransactions are sent
* Created Date    :--   20th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/
public class SendHttpCallout {
    // Asynchronous callout 
    @future(callout = true)
    public static void makeCallout(set < Id > transIds) {
        List < TransactionItem__c > transItemsList = new List < TransactionItem__c > ();
        List < Transaction__c > transList = new List < Transaction__c > ();
        try {
            // Adds the TransactionItems data for the TransactionIDs
            transItemsList = [SELECT Id, Name, Item_Cost__c, Transaction__c
                FROM TransactionItem__c
                WHERE Transaction__c IN: transIds
            ];
            // Creating the json Request body by using TransactionItems Wrapper Class
            TransactionItemsWrapper.Out o = new TransactionItemsWrapper.Out(transItemsList);
            String jsonBody = o.parse();
            HttpRequest request1 = new HttpRequest();
            // Set the endpoint URL.
            String endpoint = 'http://yourHost/yourService';
            request1.setEndPoint(endpoint);
            request1.setMethod('POST');
            // The content to be in JSON format, encoded in the UTF-8 character encoding 
            request1.setHeader('Content-Type', 'application/json');
            request1.setBody(jsonBody);
            system.debug('TransactionItems========>' + jsonBody);
            // Send the HTTP request and get the response.
            HttpResponse response1 = new HTTP().send(request1);

            if (response1.getStatusCode() != 400) {
                // Adds the Transaction data for the TransactionIDs
                transList = [SELECT Id, Name, Total_Cost__c, Total_Discount__c, Transaction_Count__c, CreatedDate
                    FROM Transaction__c
                    WHERE Id IN: transIds
                ];
                // Creating the json Request body by using TransactionItems Wrapper Class
                TransactionWrapper.Out o1 = new TransactionWrapper.Out(transList);
                jsonBody = o1.parse();
                request1.setBody(jsonBody);
                system.debug('Transactions========>' + jsonBody);
                // Send the HTTP request and get the response.
                HttpResponse response2 = new HTTP().send(request1);
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}