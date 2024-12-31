### create#PostalAddress

```json
{
    "toName": "Demo Customer Company",
    "address1": "2004 Factory Blvd",
    "city": "Orem",
    "stateProvinceGeoId": "UT",
    "postalCode": "84057",
    "countryGeoId": "USA",
}

```
This would be the base api the uses entity rest method to create ContactMech and PostalAddress records in the database.
1. Parameters
    * Input Parameters
        * postalAddressJson (type=Map)
    * Output Parameters
        * contactMechId


Prepare data in following JSON format and call 

`create#org.apache.ofbiz.party.contact.ContactMech`

```json

{
  "contactMechTypeId": "POSTAL_ADDRESS",
  "postalAddress": {
    "toName": "Demo Customer Company",
    "address1": "2004 Factory Blvd",
    "city": "Orem",
    "stateProvinceGeoId": "UT",
    "postalCode": "84057",
    "countryGeoId": "USA",
  }
}
```
