/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   Test class to insert Transactions and TransactionItems for the Trigger to fire and to mock the response which will lead to send the second request in sendHttpCallout. 
* Created Date    :--   20th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/

@isTest
global class sendCalloutMockTest implements HttpCalloutMock {
    // Implement the HttpCalloutMock interface to generate a Fake Response
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        String resBody = 'Successfully Received';
        response.setBody(resBody);
        response.setStatusCode(200);
        return response;
    }
    @isTest static void testPostCallout() {
        Transaction__c t = new Transaction__c(Name = 'TestTransaction', Total_Cost__c = 220.34, Total_Discount__c = 20.20, Transaction_Count__c = 2);
        insert t;
        List < TransactionItem__c > tItemsList = new List < TransactionItem__c > ();
        TransactionItem__c tI1 = new TransactionItem__c(Name = 'TestTItem1', Item_Cost__c = 100.45, Transaction__c = t.id);
        tItemsList.add(tI1);
        TransactionItem__c tI2 = new TransactionItem__c(Name = 'TestTItem2', Item_Cost__c = 100.45, Transaction__c = t.id);
        tItemsList.add(tI2);
        database.insert(tItemsList);
        Set < Id > transID = new set < Id > ();
        transID.add(t.Id);
        // This causes a fake response to be generated
        Test.setMock(HttpCalloutMock.class, new sendCalloutMockTest());
      	// Call the method that invokes a callout 
        SendHttpCallout.makeCallout(transID);
    }
}
