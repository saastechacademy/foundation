# findOrCreate#Customer (Application Layer)
1. Parameters
    * Input
        * externalId
        * firstName
        * lastName
        * dataSourceId
        * email
    * Output
        * partyId
2. Set partyId = where Party.externalId=externalId and Party.dataSourceId=dataSourceId (ignore-if-empty)
3. If partyId = null
   * Call create#org.apache.ofbiz.party.contact.ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:email]
   * Call create#org.apache.ofbiz.party.party.Party for [partyTypeId:"PERSON", dataSourceId:dataSourceId, person:[firstName:firstName, lastName], roles:[[roleTypeId:"CUSTOMER"]],contactMechs:[[contactMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"PRIMARY_EMAIL"]]]
   * set partyId = createPartyOutput.partyId
