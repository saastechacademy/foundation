# create#org.apache.ofbiz.party.party.Party

```json
{
  "partyId": "COMPANY",
  "partyTypeId": "PARTY_GROUP",
  "partyGroup": {
    "groupName": "NotNaked Fashion Inc"
  }
}

```

```json
{
  "partyTypeId": "PERSON",
  "person": {
    "firstName": "Good",
    "lastName": "Person"
  }
}

```

API for managing Person and PartyGroup. 

There is no reason to create Party independent of PartyGroup or Person. We should see it as Abstract class, it cannot be instantiated on its own. 

