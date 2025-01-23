# co.hotwax.oms.PartyServices.create#Person
1. Parameters
    * Input
        * externalId
        * dataSourceId
        * firstName
        * lastName
        * contactMechs (list of [contactMechId:<contactMechId>, purposes:[[contactMechPurposeTypeId:<contactMechPurposeTypeId>]]])
        * roles (list of [roleTypeId:<roleTypeId>])
        * identifications (list of [partyIdentificationTypeId:<partyIdentificationTypeId>, idValue:<idValue>])
    * Output
        * partyId
2. Call create#Party for [partyTypeId:"PERSON", externalId:externalId, dataSourceId:dataSourceId].
3. Set partyId = createPartyOutput.partyId.
4. Call create#Person for context.

In parameters

```json
{
   "externalId": "6911550881956",
   "dataSourceId": "SHOPIFY",
   "firstName": "Good",
   "lastName": "Person",
   "contactMechs": [
      {
         "contactMechId": "10010",
         "purposes": [
            {
               "contactMechPurposeTypeId": "PRIMARY_EMAIL"
            }
         ]
      }
   ],
   "roles": [
      {
         "roleTypeId": "CUSTOMER"
      }
   ],
   "identification": [
      {
         "identificationTypeId": "SHOPIFY_CUST_ID",
         "idValue": "6911550881956"
      }
   ]
}
```