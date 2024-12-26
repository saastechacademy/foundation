


```xml

<!-- Add following field Payment entity -->
<!-- Use data type that allows more than 30 chars in ID field.  -->
<entity-facade-xml>
<extend-entity entity-name="Payment">
    <!-- Custom Field -->
    <field name="externalTypeId" type="id">
        <description>External Type Identifier for the Payment</description>
    </field>
</extend-entity>
</entity-facade-xml>

<entity-facade-xml>
    <!-- PaymentGroup Entity, these entities exists in ofbiz. may be deleted recently. -->
    <entity entity-name="PaymentGroup" package-name="org.apache.ofbiz.accounting.payment" title="Payment Group">
        <description>Payment Group</description>
        <field name="paymentGroupId" type="id"/>
        <field name="paymentGroupTypeId" type="id"/>
        <field name="paymentGroupName" type="very-long"/>
        <!-- Custom fields -->
        <field name="amount" type="currency-amount"/>
        <field name="statusId" type="id"/>
        <prim-key field="paymentGroupId"/>
        <relation type="one" fk-name="PAYMNTGP_PGTYPE" rel-entity-name="PaymentGroupType">
            <key-map field-name="paymentGroupTypeId"/>
        </relation>
    </entity>

    <!-- PaymentGroupType Entity -->
    <entity entity-name="PaymentGroupType" package-name="org.apache.ofbiz.accounting.payment" title="Payment Group Type">
        <description>Payment Group Type</description>
        <field name="paymentGroupTypeId" type="id"/>
        <field name="parentTypeId" type="id"/>
        <field name="hasTable" type="indicator"/>
        <field name="description" type="description"/>
        <prim-key field="paymentGroupTypeId"/>
        <relation type="one" fk-name="PAYMNTGP_TYP_PAR" title="Parent" rel-entity-name="PaymentGroupType">
            <key-map field-name="parentTypeId" rel-field-name="paymentGroupTypeId"/>
        </relation>
    </entity>

    <!-- PaymentGroupMember Entity -->
    <entity entity-name="PaymentGroupMember" package-name="org.apache.ofbiz.accounting.payment" title="Payment Group Member">
        <description>Payment Group Member</description>
        <field name="paymentGroupId" type="id"/>
        <field name="paymentId" type="id"/>
        <field name="fromDate" type="date-time"/>
        <field name="thruDate" type="date-time"/>
        <field name="sequenceNum" type="numeric"/>
        <prim-key field="paymentGroupId"/>
        <prim-key field="paymentId"/>
        <prim-key field="fromDate"/>
        <relation type="one" fk-name="PAYGRPMMBR_PG" rel-entity-name="PaymentGroup">
            <key-map field-name="paymentGroupId"/>
        </relation>
        <relation type="one" fk-name="PAYGRPMMBR_PAYMNT" rel-entity-name="Payment">
            <key-map field-name="paymentId"/>
        </relation>
    </entity>

<entity entity-name="FinAccountTrans" package-name="org.apache.ofbiz.accounting.finaccount" title="Financial Account Transaction">
    <description>Financial Account Transaction with a PaymentGroup association</description>

    <!-- Fields -->
    <field name="finAccountTransId" type="id"/>
    <field name="finAccountTransTypeId" type="id"/>
    <field name="finAccountId" type="id"/>
    <field name="partyId" type="id"/>
    <field name="glReconciliationId" type="id"/>
    <field name="transactionDate" type="date-time"/>
    <field name="entryDate" type="date-time"/>
    <field name="amount" type="currency-amount"/>
    <field name="paymentId" type="id"/>
    <field name="orderId" type="id"/>
    <field name="orderItemSeqId" type="id">
        <description>Points to an OrderItem that represents the purchase of a product to add money to the account.</description>
    </field>
    <field name="performedByPartyId" type="id"/>
    <field name="reasonEnumId" type="id"/>
    <field name="comments" type="comment"/>
    <field name="statusId" type="id"/>

    <!-- Custom field -->
    <field name="paymentGroupId" type="id">
        <description>Associated PaymentGroup for this financial account transaction.</description>
    </field>

    <!-- Primary Key -->
    <prim-key field="finAccountTransId"/>

    <!-- Relationships -->
    <relation type="one" fk-name="FINACCT_TX_TYPE" rel-entity-name="FinAccountTransType">
        <key-map field-name="finAccountTransTypeId"/>
    </relation>
    <relation type="many" rel-entity-name="FinAccountTransTypeAttr">
        <key-map field-name="finAccountTransTypeId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_FNACT" rel-entity-name="FinAccount">
        <key-map field-name="finAccountId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_PARTY" rel-entity-name="Party">
        <key-map field-name="partyId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_PMT" rel-entity-name="Payment">
        <key-map field-name="paymentId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_ODITM" rel-entity-name="OrderItem">
        <key-map field-name="orderId"/>
        <key-map field-name="orderItemSeqId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_PBPTY" title="PerformedBy" rel-entity-name="Party">
        <key-map field-name="performedByPartyId" rel-field-name="partyId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_REAS_ENUM" title="Reason" rel-entity-name="Enumeration">
        <key-map field-name="reasonEnumId" rel-field-name="enumId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_STI" rel-entity-name="StatusItem">
        <key-map field-name="statusId"/>
    </relation>
    <relation type="one" fk-name="FIN_ACT_TX_GLREC" rel-entity-name="GlReconciliation">
        <key-map field-name="glReconciliationId"/>
    </relation>

    <!-- Custom Relationship -->
    <relation type="one" fk-name="FIN_ACT_TX_PYGRP" rel-entity-name="PaymentGroup">
        <key-map field-name="paymentGroupId"/>
    </relation>
</entity>
</entity-facade-xml>




```