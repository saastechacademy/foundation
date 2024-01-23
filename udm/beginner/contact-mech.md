The UDM, among its various features, it includes a system for managing contact mechanisms, which is primarily handled through the ContactMech table and its related tables.

1. ContactMech Table
* Purpose: This table is the central table in the contact mechanism schema. The ContactMech entity is used to store the information meant for contacting party.
* Fields: Common fields include contactMechId(primary key), contactMechTypeId, infoString, etc.
* Usage: The infoString field is used to store the actual contact information, such as an email address while Telecom number and postal address have some additional fields hence they have separate table.

Related Tables

2. TelecomNumber Table

* Relationship with ContactMech: This table is related to ContactMech and specifically stores telephone numbers. It has a one-to-one relationship with ContactMech.
* Fields: Includes contactMechId(primary key), countryCode, areaCode, contactNumber, askForName etc.
* Usage: Used to store detailed telephone contact information. The contactMechId field links it to the ContactMech table.

3. PostalAddress Table
* Relationship with ContactMech: This table stores the postal address information and is linked to the ContactMech table. It also has one-to-one relationship with ContactMech.
* Fields: Includes contactMechId(primary key), toName, attnName, address1, address2, city, postalCode, etc.
* Usage: Stores detailed information about postal addresses. The contactMechId field serves as the link to the ContactMech table.

4. Email Addresses in ContactMech
* Handling: Email addresses are managed directly in the ContactMech table, typically using the infoString field.
* No Dedicated Table: Unlike telephone numbers and postal addresses, there is no dedicated table for email addresses.

Sample Data in JSON Format

```
{
  "ContactMech": [
    {
      "contactMechId": "10000",
      "contactMechTypeId": "TELECOM_NUMBER"
    },
    {
      "contactMechId": "10001",
      "contactMechTypeId": "EMAIL_ADDRESS",
      "infoString": "example@email.com"
    },
    {
      "contactMechId": "10002",
      "contactMechTypeId": "POSTAL_ADDRESS"
    }
  ],
  "TelecomNumber": {
        "contactMechId": "10001"
        "countryCode": "1",
        "areaCode": "123",
        "contactNumber": "4567890"
  },
  "PostalAddress": {
        "contactMechId": "10002"
        "toName": "John Doe",
        "attnName": "Office",
        "address1": "123 Main St",
        "address2": "Suite 100",
        "city": "Metropolis",
        "postalCode": "12345"
  }
}

```

In this sample JSON data:

A telecom number is linked to the ContactMech table through contactMechId and detailed in the TelecomNumber object.
An email address is stored as an infoString in the ContactMech table.
A postal address is linked via contactMechId and detailed in the PostalAddress object.
