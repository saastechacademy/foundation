# create#org.apache.ofbiz.party.party.Party

This service is intended to create only Party record. It should be seen as an abstract class with Person and PartyGroup as its implementation.

It is meant to be called inline in [create#Person](createPerson.md) and create#PartyGroup services.

```json
{
  "partyTypeId": "PERSON",
  "externalId": "6911550881956",
  "dataSourceId": "SHOPIFY"
}
```