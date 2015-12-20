# NewRandomizer
Picks up the work of Cody Sechelski as posted here: http://www.codebycody.com/2012/02/sfdc-randomizer.html

Beth Breisnes (@bethbrains) raised the issue of making it a invocable method so that's what we're supposed to do here over the Christmas holidays (2015 that is, in case I get slacking...).

Cody's documentation was as follows, to use it for the time being. 

http://www.codebycody.com/2012/02/sfdc-randomizer.html

SFDC Randomizer

Let’s get random here for a moment.
Have you ever needed a random number in Salesforce.com? Or maybe you need to pick a random value from a list or have the system return a random Boolean value. Here is the solution, the SFDC Randomizer class. Install this randomizer class in your org and call the available methods from any other APEX class or trigger.

This class is all built off of the getRandomNumber method which can be called to generate a random integer, but also provides a “random seed” for the other methods in the class. So if you choose to only copy individual methods to an existing class, be sure to understand which other methods will be called and copy those as well.

The table below shows the available methods, their arguments and what they return: 
Name	Arguments	Return Type	Description
getRandomNumber
Integer size		The size integer represents the maximum value that can be returned.
For example:
getRandomNumber(10) could return any number between 0 and 9. getRandomNumber(1000) could return any umber between 0 and 999.
getRandomBoolean
Boolean	Randomly returns either true or false.
getRandomString
Liststrings	String	Returns a random item from the list of strings. A good use for this is to select a random object by passing a list of Salesforce ID string.
getRandomPickListValue
SObject s_object
String field_name
Boolean allow_blank	String	Returns a random picklist value for a given object and field name. This good use for this is for randomizing values when creating “dummy” objects in a new sandbox or for testing.
NOTE: This method uses a describe call within a loop. At the time of writing this post there is a governor limit of 100 describe calls per execution. This will cause an error if the object has over 100 field, or if you call it from a loop. If you need to loop through a number of records, consider calling the getPicVals method outside your loop, then use getRandomString to select as random value.
getPicVals
SObject s_object	Map<String,List<String>>	Returns a map of all picklist/multi-picklist fields and their values for a given object. The key for each map entry is the name of the field and the value is a list of strings representing the picklist values.
NOTE: The field names in the keyset are in proper case (My_Custom_Field__c rather than my_custom_field__c). Keep this in mind when you attempt to get a value from the map.
getPlaceholderText
Integer length	String	Returns placeholder (Lorem Ipsum) text of a certain length. This is not a full-fledged Lorem Ipsum generator, but it should do the trick for most cases.
More about Lorem Ipsum
NOTE: in an effort to maintain proper sentence structure without adding too much logic, it is possible for the returned string to be up to two characters shorter than the length argument, but never more.

Usage and Examples

Example 1 - Generating a random number
Once you have the randomizer class in your org, you can generate a random number using the following code.
?

Integer i = randomizer.getRandomNumber(10);
The argument for the getRandomNumber method represents the number of possible results. So if you entered 10, the possible results could be from 0-9. If you entered 1000, the possible results could be from 0-999.
Example 2 - Update a record with a random picklist value

For a single record, you can use the getRandomPicklistValue. However, this should not be called from a loop because the method uses describe calls and there are only 100 describe calls allowed in a single execution. See example 3 below on how to use the getPickVals method to get around this governor limit.

Account a = [select id, AccountSource from account limit 1];
a.AccountSource = randomizer.getRandomPicklistValue(a,'AccountSource',true);
update a;
Example 3 - Populating a config sandbox with randomized sample data
So let's say you just created a new config or developer sandbox and yo need to load in some "dummy" records for testing your new development. You can create more realistic data by randomizing the field values. Here, we can create a number of Accounts with randomized values.
?

//Gets a map of all picklist/multiselect picklists for the account object
//as well as the field values. Use this instead of calling the getRandomPicklistValue
//method from within a loop which will likely result in too many describe calls
private Map<String,List<String>> accountPicVals = randomizer.getPicVals(new Account());
 
//Number of Accounts to Insert
Integer createNumber = 10;
 
//List to hold the new accounts in memory so they can all be inserted at one time
List<Account> accontList = new List<Account>();
 
//Create the new accounts and randomize the values
for(Integer i = 0; i < createNumber; i++){
 Account a = new Account();
 a.Name = 'Account ' + i;
 a.Site = randomizer.getPlaceholderText(20);
 a.AccountSource = randomizer.getRandomString(accountPicVals.get('AccountSource'));
 a.NumberOfEmployees = randomizer.getRandomNumber(1000);
 accontList.add(a);
}
 
//Insert the new Accounts
insert accontList;
Example 4 - Get random cases for a quality audit
Here we will create a visualforce page that a manager can use to pull 10 random cases created today for a quality control audit.

Visualforce Page
?
<apex:page controller="randomTesterController">
    <ul>
        <apex:repeat value="{!RandomCaseIDs}" var="c">
            <li><a target="_blank" href="/{!c}">{!c}</a></li>
        </apex:repeat>
    </ul>
</apex:page>

APEX Controller
?

public class randomTesterController {
 
    public Set<String> RandomCaseIDs {get;set;}
 
    public randomTesterController(){
 
        //Number of random cases to be returned
        Integer numberOfCases = 10;
 
        //Query the cases, modify the where clause to fit your needs
        List<Case> cases = [select id from case where createddate = today];
 
        //Make sure there are enough records
        if(cases.size() >= numberOfCases){
 
            //create a list of strings to pass to our randomizer method
            List<String> caseIDs = new List<String>();
            for(Case c : cases){
                caseIDs.add(c.Id);
            }
 
            //create a set to hold the returned ids so that we can make sure there are no dupliates
            Set<String> usedIds = new Set<String>();
 
            //Now lets get the random Case IDs
            for(Integer i=0; i<numberOfCases; i++){
                String randomId = randomizer.getRandomString(caseIDs);
                //check for duplicates
                while(usedIDs.contains(randomId)){
                    randomId = randomizer.getRandomString(caseIDs);
                }
                usedIDs.add(randomId);
            }
            RandomCaseIDs = usedIDs;
        }
        else{
            //TODO:handle exception
        }
    }
}

Thanks so much for reading. I hope you found this post to be helpful. If you did, I would appreciate a comment or two. They are the fuel that give me the energy to keep posting. Also , let me know if you had any problems getting this solution to work for you and I will do my best to get back with you as soon as I can.
