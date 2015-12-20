global class RandomizerObject {
	
	@InvocableVariable
	global string sObjectTypeName;
	
	@InvocableVariable(required=true)
	global string sObjectFieldName;
	
	@InvocableVariable
	global List<sObject> sObjects;
	
	@InvocableVariable
	global sObject obj;
	
	global RandomizerObject(sObject o, string field) {
	if (field != NULL) {
		this.sObjects.add(o);
		this.sObjectFieldName = field;
	}
	else {
		throw new RandomizerException('A field name must be provided when calling the Randomizer Class invocable method. Correct Initialisation requires an object or a list of objects and a field name to randomize.');
	}
		
	}
	
	global RandomizerObject(sObject[] lO) {
	if (field != NULL) {
		this.sObjects.addAll (lO);
	}
	else {
		throw new RandomizerException('A field name must be provided when calling the Randomizer Class invocable method. Correct Initialisation requires an object or a list of objects and a field name to randomize.');
	}
	}
}