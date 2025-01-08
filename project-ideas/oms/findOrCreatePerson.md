# co.hotwax.oms.PartyServices.findOrCreate#Person (OMS)
1. Parameters
    * Input
        * externalId
        * firstName
        * lastName
        * dataSourceId
        * contactMechs (list of [contactMechId:<contactMechId>, purposes:[[contactMechPurposeTypeId:<contactMechPurposeTypeId>]]])
        * roles (list of [roleTypeId:<roleTypeId>])
        * identifications (list of [partyIdentificationTypeId:<partyIdentificationTypeId>, idValue:<idValue>])
    * Output
        * partyId
2. Set partyId = where Party.externalId=externalId and Party.dataSourceId=dataSourceId (ignore-if-empty)
3. If partyId = null
   * If firstName and lastName are null return error "Party not found with externalId: ${externalId}. Couldn't create a Party for null firstName and lastName."
   * Call create#Person in context
   * set partyId = createPersonOutput.partyId

[create#Person](createPerson.md)