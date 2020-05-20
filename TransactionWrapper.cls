/**************************************************************************************************
* Project         :--   Katzion - Technical Task
* Description     :--   Transaction Wrapper class to prepare the request data in json format as per the format given
* Created Date    :--   20th May 2020
* Author		  :--	Madhusudhan Chelur Suresh
===========================================Modification Log =======================================
Version     Author              Date            Description     
===================================================================================================*/
public class TransactionWrapper {
    public class Out {
        // List of Key Value pairs 
        list < RequestJSON > jsonObj = new list < RequestJSON > ();
        // Parameterised Constructor to set the values 
        public Out(List < Transaction__c > transList) {
            for (Transaction__c t: transList) {
                // Adds values to as Key-Value pairs for the list
                jsonObj.add(new RequestJSON(new keysClass(t.Id), new transClass(string.ValueOf(t.Total_Cost__c), string.ValueOf(t.Total_Discount__c), Date.valueOf(t.CreatedDate), string.ValueOf(t.Transaction_Count__c))));
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
        public transClass Values;
        // Parameterised Constructor to set the values 
        RequestJSON(keysClass k, transClass t) {
            Keys = k;
            Values = t;
        }
    }
    // Keys Wrapper
    public class KeysClass {
        public String TransactionID;
        // Parameterised Constructor to set the values 
        public keysClass(String s) {
            TransactionID = s;
        }

    }
    // Transaction data Wrapper (Values wrapper)
    public class TransClass {
        public String TotalCost;
        public String TotalDiscount;
        public Date TransactionDate;
        public String TotalCount;
        // Parameterised Constructor to set the values 
        public transClass(String tcost, String tdiscount, Date tDate, String tCount) {
            TotalCost = tcost;
            TotalDiscount = tdiscount;
            TransactionDate = tDate;
            TotalCount = tCount;
        }
    }
}