# CustomMethod

The `CustomMethod` entity in Apache OFBiz is designed to store and manage user-defined or custom methods within the system. It allows for extending the functionality of OFBiz beyond its standard features, providing a way to implement business-specific logic or integrations.

**Key attributes of the `CustomMethod` entity:**

*   `customMethodId`: A unique identifier for the custom method.
*   `customMethodTypeId`: The ID of the associated `CustomMethodType`, which categorizes the custom method.
*   `customMethodName`: The name of the custom method, often used for identification and invocation.
*   `description`: A textual description of the custom method's purpose or functionality.

**Relationship with `CustomMethodType`**

*   The `CustomMethod` entity has a many-to-one relationship with the `CustomMethodType` entity through the `customMethodTypeId` foreign key. This means that each custom method belongs to one specific custom method type, allowing for categorization and organization of custom methods.

**Use Cases in Shipping Integration**

While the provided code snippets don't directly showcase the use of `CustomMethod` in shipping integration, here are some potential scenarios where it could be leveraged:

*   **Custom Shipping Calculation:** If HotWax Commerce has specific business rules or algorithms for calculating shipping costs that differ from the standard OFBiz logic, they could implement a custom service and store its details in a `CustomMethod` record. The `customMethodTypeId` could be something like "SHIPPING_CALCULATION" to categorize it appropriately.

*   **Carrier-Specific Integrations:** If HotWax Commerce needs to integrate with a shipping carrier that is not supported out-of-the-box by OFBiz, they could develop custom services to handle the communication and data exchange with that carrier's API. These custom services could be stored as `CustomMethod` records, potentially categorized under a `CustomMethodType` like "CARRIER_INTEGRATION."

*   **Custom Shipping Labels or Documentation:** If HotWax Commerce requires specific formatting or additional information on shipping labels or other shipping-related documents, they could create custom services to generate these documents and store their details in `CustomMethod` entities.

*   **Specialized Shipping Workflows:** HotWax Commerce might have unique workflows or processes related to shipping that are not covered by the standard OFBiz functionality. These custom workflows could be implemented using custom services and managed through the `CustomMethod` entity.

**In essence**, the `CustomMethod` entity, in conjunction with `CustomMethodType`, provides a flexible and extensible mechanism to incorporate custom logic and integrations into the HotWax Commerce shipping and fulfillment processes, allowing the system to adapt to specific business needs and requirements beyond the standard OFBiz capabilities.

```
    <!-- ========================================================= -->
    <!-- org.apache.ofbiz.common.method -->
    <!-- ========================================================= -->

    <entity entity-name="CustomMethod"
        package-name="org.apache.ofbiz.common.method"
        default-resource-name="CommonEntityLabels"
        title="Custom Method">
        <field name="customMethodId" type="id"></field>
        <field name="customMethodTypeId" type="id"></field>
        <field name="customMethodName" type="long-varchar"></field>
        <field name="description" type="description"></field>
        <prim-key field="customMethodId"/>
        <relation type="one" fk-name="CME_TO_TYPE" rel-entity-name="CustomMethodType">
            <key-map field-name="customMethodTypeId"/>
        </relation>
    </entity>
    <entity entity-name="CustomMethodType"
        package-name="org.apache.ofbiz.common.method"
        title="Custom Method Type">
        <field name="customMethodTypeId" type="id"></field>
        <field name="parentTypeId" type="id"></field>
        <field name="hasTable" type="indicator"></field>
        <field name="description" type="description"></field>
        <prim-key field="customMethodTypeId"/>
        <relation type="one" fk-name="CME_TYPE_PARENT" title="Parent" rel-entity-name="CustomMethodType">
            <key-map field-name="parentTypeId" rel-field-name="customMethodTypeId"/>
        </relation>
    </entity>

```
