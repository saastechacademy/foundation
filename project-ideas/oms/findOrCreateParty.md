# findOrCreate#Party
1. Parameters
    * Input
        * externalId
        * firstName
        * lastName
        * dataSourceId
        * email
        * roles (list of [roleTypeId:<roleTypeId>])
        * identifications (list of [partyIdentificationTypeId:<partyIdentificationTypeId>, idValue:<idValue>])
    * Output
        * partyId
2. Set partyId = where Party.externalId=externalId and Party.dataSourceId=dataSourceId (ignore-if-empty)
3. If partyId = null
   * If firstName and lastName are null return error "Party not found with externalId: ${externalId}. Couldn't create a Party for null firstName and lastName."
   * Initialize partyContext = [partyTypeId:"PERSON", dataSourceId:dataSourceId, person:[firstName:firstName, lastName]]
   * If email != null, call create#org.apache.ofbiz.party.contact.ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:email]
   * Set emailContactMechId = createContactMechOutput.contactMechId
   * If emailContactMechId != null, set partyContext.contactMechs = [[contactMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"PRIMARY_EMAIL"]]
   * If roles !=null, set partyContext.roles = roles
   * If identifications != null, set partyContext.identifications = identifications
   * Call create#org.apache.ofbiz.party.party.Party for partyContext
   * set partyId = createPartyOutput.partyId
