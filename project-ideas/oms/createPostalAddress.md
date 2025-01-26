### co.hotwax.oms.ContactMechServices.create#PostalAddress (OMS)

1. Parameters
    * Input
        * toName
        * address1
        * address2
        * city
        * postalCode
        * stateProvinceGeoId
        * countryGeoId
        * latitude
        * longitude
    * Output
        * contactMechId
2. Call create#ContactMech for [contactMechTypeId:"POSTAL_ADDRESS"].
3. Set contactMechId = createContactMechOutput.contactMechId.
4. Call create#PostalAddress for context

```json
{
  "toName": "Demo Customer Company",
  "address1": "2004 Factory Blvd",
  "address2": "",
  "city": "Orem",
  "stateProvinceGeoId": "UT",
  "postalCode": "84057",
  "countryGeoId": "USA",
  "latitude": "40.7650225",
  "longitude": "40.7650225"
}

```
