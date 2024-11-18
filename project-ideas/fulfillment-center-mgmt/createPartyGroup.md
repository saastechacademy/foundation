Rest API for managing PartyGroup. 

There is no reason to create Party independent of PartyGroup of Person. We should see it as Abstract class, it cannot be instantiated on its own. 

createPartyGroup should accept all fields in Party and PartyGroup entity. 
Keep it simple, If you pass in partyId, and insert fails because of duplicate key, it fails, return natural error. Don't process it in anyways. 

Similarly, implement 
updatePartyGroup 
deletePartyGroup

createPerson
updatePerson
deletePerson. 


The Ofbiz implementation considers status, We don't want to. 
