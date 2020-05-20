/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   TransactionItems Wrapper class to prepare the request data in json format as per the format given
* Created Date    :--   20th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/
public class TransactionItemsWrapper {
    public class Out {
        list < RequestJSON > jsonObj = new list < RequestJSON > ();
        // Parameterised Constructor to set the values 
        public out(List < TransactionItem__c > tItemsList) {
            for (TransactionItem__c tI: tItemsList) {
                // Adds values to as Keys-Values pairs for the list
                jsonObj.add(new RequestJSON(new keysClass(tI.Transaction__c), new tItemsClass(string.ValueOf(tI.Item_Cost__c), tI.Name)));
            }
        }
        // Sends the json Object list as a String
        public String parse() {
            return json.serialize(jsonObj);
        }
    }
    // Keys-Values Wrapper
    public class RequestJSON {
        public keysClass Keys;
        public tItemsClass Values;
        // Parameterised Constructor to set the values 
        RequestJSON(keysClass k, tItemsClass t) {
            Keys = k;
            Values = t;
        }
    }
    // Keys Wrapper
    public class KeysClass {
        public String TransactionItemID;
        // Parameterised Constructor to set the values 
        public keysClass(String s) {
            TransactionItemID = s;
        }
    }
    // Transaction Item data Wrapper (Values wrapper)
    public class TItemsClass {
        public String ItemCost;
        public String ItemName;
        // Parameterised Constructor to set the values 
        public TItemsClass(String cost, String name) {
            ItemCost = cost;
            ItemName = name;
        }
    }
}