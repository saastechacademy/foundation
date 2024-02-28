The UDM, among its various features, it includes a system for managing contact mechanisms, which is primarily handled through the ContactMech table and its related tables.

1. ContactMech Table
* Purpose: It is the medium to contact to party. This entity is the central entity or master entity in the contact mechanism schema. It stores different types of contact information for the party.
* Fields: Common fields include contactMechId, contactMechTypeId, infoString, etc.
* Usage: The infoString field is used to store the actual contact information, such as an email address.
* Type of contact mechanism: There are various ways to contact with party i.e. email address, phone number, fax, postal address or etc.

Related Tables

2. TelecomNumber Table
* TELECOMMUNICATIONS NUMBER includes any access via telecommunications lines such as phones, faxes, modems, pagers, and cellular numbers.
* Fields: Includes contactMechId, countryCode, areaCode, contactNumber, etc.
* Usage: Used to store detailed telephone contact information. The contactMechId field links it to the ContactMech table.

3. PostalAddress Table
* The POSTAL ADDRESS entity maintains all addresses used by the enterprise in a central place, it is connected to ContactMech via contactMechId.
  
* Fields: Includes contactMechId (foreign key), toName, attnName, address1, address2, city, postalCode, etc.
  
* Usage: PostalAddress entity stores the details of address of party's address1, address2 , houseNumber, city, postalCode, countryCode etc.
The contactMechId field serves as the link to the ContactMech table.

4. Email Addresses in ContactMech
* Handling: Email addresses are managed directly in the ContactMech table, typically using the infoString field.
* No Dedicated Table: Unlike telephone numbers and postal addresses, there is no dedicated table for email addresses.

Sample Data in JSON Format

```
{
      "ContactMech":
 [
     {
        "contactMechId": "100000",
        "contactMechTypeId": "TELECOM_NUMBER"
     },
     {
        "contactMechId": "10002",
        "contactMechTypeId": "POSTAL_ADDRESS"
     },

     {
        "contactMechId": "10001",
        "contactMechTypeId": "EMAIL_ADDRESS",
        "infoString": "example@email.com"
     }
   ],    
      "TelecomNumber":[
      {
        "countryCode": "1",
        "areaCode": "123",
        "contactNumber": "4567890"
      }
    ],
      "PostalAddress": [
     {
        "contactMechId": "10002",
        "toName": "John Doe",
        "attnName": "Office",
        "address1": "123 Main St",
        "address2": "Suite 100",
        "city": "Metropolis",
        "postalCode": "12345"
      }
    ]
}

```
In this sample JSON data:

A telecom number is linked to the ContactMech table through contactMechId and detailed in the TelecomNumber object.
An email address is stored as an infoString in the ContactMech table.
A postal address is linked via contactMechId and detailed in the PostalAddress object.
