/**
 * Copyright (c) Daniel Stange <daniel.stange@die-interaktiven.de>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a 
 * copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software 
 * is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

/**
 * Set a random value to any generic field of a generic object from within Process Builder
 * 
 * Builds upon an article by Andrew Fawcett on Bulkification for invocable methods. Read it, it's 
 * great: http://andyinthecloud.com/2015/05/25/automating-org-setup-via-process-builder-and-metadata-api/
 * Thank you, Andy!
 * 
 * Daniel Stange (dst) <daniel.stange@die-interaktiven.de>
 * 
 * 0.1	2015-12-20	(dst) Skeleton class for implementation 
 *  
 * 
**/
global class RandomizeField {
    
    global class Request  {
        
        @InvocableVariable(required=true label='ID of the Object')
        global ID objId;
        
        @InvocableVariable(required=true label='Field to randomize')
        global string sObjectFieldName;
        
    }
    
    @InvocableMethod(label='Set a random value to any boolean, number, currency, picklist, text field')
    
    global static void randomize(List<Request> requests) {
        System.enqueueJob(new randomize(UserInfo.getSessionId(), requests));
    }
    
    public class randomize implements System.Queueable {
        
        private final String sessionId;
        private final List<Request> requests;
        
        public randomize(String sessionId, List<Request> requests) {
            this.sessionId = sessionId;
            this.requests = requests;
        }
        
        public void execute(System.QueueableContext context) {
            
            List<sObject> objToUpdate = new List<sObject>();
            Map<ID, Request> mRequests;
            Set<ID> objsInRequests;
            
            
            // identify the type
            // check if the field name provided points to a field on the object 
            // check if a method 
            // fetch all objects
            // run the matching randomizer method.
            // save all records again
        	
                if (!objToUpdate.isEmpty() ) {
                    objToUpdate.sort();
                    
                    try {
                        update(objToUpdate);
                    } 
                    catch (Exception e) {
                        // error handling 
                    }
                }
        }
    }
}