# UniMail: Uniform Email Microservice API

UniMail is a multi-tenant microservice that provides a unified API interface for integrating with different email providers including Klaviyo, Iterable, and custom SMTP-based systems. It abstracts away the differences in provider-specific APIs, offering two consistent endpoints:

- `POST /email/send`: to send a transactional or marketing email
- `POST /email/event`: to track a behavioral or lifecycle event

All requests to UniMail require the following HTTP headers:

- `tenant_id`: Unique identifier for the calling tenant
- `api_key`: Used to authenticate and authorize the caller
- `config_id`: Specifies the email gateway configuration to use

This document defines the APIs and their mapping to Klaviyo and Iterable.

---

## API: `POST /email/send`

### Purpose
Send a transactional or templated email to a user. This could be a shipping notification, pickup reminder, or order confirmation.

### Request Format
```json
{
  "emailType": "ORDER_SHIPPED",
  "emailAddress": "user@example.com",
  "templateData": {
    "orderId": "ORDER123",
    "trackingUrl": "https://..."
  },
  "language": "en",
  "test": false
}
```

### Behavior
- For **SMTP**, the service renders an internal template using `emailType` and sends via SMTP.
- For **Klaviyo**, it maps `emailType` to a `metric.name` and posts an event to `/api/events/`, triggering a flow.
- For **Iterable**, it maps `emailType` to a configured `campaignId` and calls `/email/target`.

### Mapping
#### Klaviyo
| UniMail Field         | Klaviyo Field                        |
|----------------------|--------------------------------------|
| `emailType`          | `metric.attributes.name`             |
| `emailAddress`       | `profile.attributes.email`           |
| `templateData`       | `attributes.properties`              |

**Endpoint:** `POST https://a.klaviyo.com/api/events/`

#### Iterable
| UniMail Field         | Iterable Field                       |
|----------------------|--------------------------------------|
| `emailType`          | resolved to `campaignId`             |
| `emailAddress`       | `recipientEmail`                     |
| `templateData`       | `data`                               |

**Endpoint:** `POST https://api.iterable.com/api/email/target`

---

## API: `POST /email/event`

### Purpose
Track a behavioral event for a user, such as cart abandonment or order viewed. These events can trigger flows inside email platforms.

### Request Format
```json
{
  "eventName": "ABANDONED_CART",
  "emailAddress": "user@example.com",
  "eventData": {
    "cartValue": "49.99",
    "productSkus": ["SKU123", "SKU124"]
  },
  "createdAt": "2025-07-30T20:21:45Z"
}
```

### Behavior
- For **Klaviyo**, this triggers a metric event via `/api/events/`, similar to `send` but with no assumption of an email.
- For **Iterable**, this maps to `/events/track`, which can optionally trigger a campaign or journey.
- For **SMTP**, this endpoint is **not supported** and will return an error.

### Mapping
#### Klaviyo
| UniMail Field         | Klaviyo Field                        |
|----------------------|--------------------------------------|
| `eventName`          | `metric.attributes.name`             |
| `emailAddress`       | `profile.attributes.email`           |
| `eventData`          | `attributes.properties`              |

**Endpoint:** `POST https://a.klaviyo.com/api/events/`

#### Iterable
| UniMail Field         | Iterable Field                       |
|----------------------|--------------------------------------|
| `eventName`          | `eventName`                          |
| `emailAddress`       | `email`                              |
| `eventData`          | `dataFields`                         |

**Endpoint:** `POST https://api.iterable.com/api/events/track`

---

## Notes on Provider Capabilities

| Capability            | SMTP  | Klaviyo | Iterable |
|-----------------------|-------|---------|----------|
| Send Email            | ✅    | ✅      | ✅       |
| Track Event           | ❌    | ✅      | ✅       |
| Use Template ID       | ❌    | ❌      | ✅       |
| Trigger Flow on Event | ❌    | ✅      | ✅       |

---

Entity defintion 

### ✅ Entities for Unimail Tenant Management

#### 1. `Party`
Represents any participant — in this context, your unimail tenant (retailer).
- `partyId` (PK)
- `partyTypeEnumId` (set to `PtyOrganization` for tenants)

#### 2. `Organization`
Extends `Party` when `partyTypeEnumId = 'PtyOrganization'`.
- `partyId` (PK, FK to Party)
- `organizationName`

#### 3. `PartyRole`
Assigns a role to a party for classification and access control.
- `partyId` (PK, FK to Party)
- `roleTypeId` (e.g., `UnimailTenant`)
- `fromDate` (PK)
- `thruDate`

---

### 📄 XML Definitions for Tenant Entities

Below are the XML definitions for the three core entities, modeled in alignment with Moqui’s UDM structure.

#### 🗂 `Party`
```xml
<entity entity-name="Party" package="co.hotwax.unimail">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="partyTypeEnumId" type="id"/>
    <field name="statusId" type="id"/>
    <field name="description" type="text-short"/>
    <field name="createdDate" type="date-time"/>

    <relationship type="one" title="PartyType" related="moqui.basic.Enumeration" short-alias="type">
        <key-map field-name="partyTypeEnumId"/>
    </relationship>
    <relationship type="one-nofk" related="co.hotwax.unimail.Organization" short-alias="organization"/>
    <relationship type="many" related="co.hotwax.unimail.PartyRole" short-alias="roles">
        <key-map field-name="partyId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="PartyType" description="Party Type"/>
        <moqui.basic.Enumeration enumId="PtyOrganization" enumTypeId="PartyType" description="Organization"/>
        <moqui.basic.Enumeration enumId="PtyPerson" enumTypeId="PartyType" description="Person"/>
    </seed-data>

    <master name="default">
        <detail relationship="type"/>
        <detail relationship="organization"/>
        <detail relationship="roles"/>
    </master>
</entity>
```

#### 🗂 `Organization`
```xml
<entity entity-name="Organization" package="co.hotwax.unimail">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="organizationName" type="name"/>

    <relationship type="one" related="co.hotwax.unimail.Party">
        <key-map field-name="partyId"/>
    </relationship>
</entity>
```

#### 🗂 `PartyRole`
```xml
<entity entity-name="PartyRole" package="co.hotwax.unimail">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="roleTypeId" type="id" is-pk="true"/>
    <field name="fromDate" type="date-time" is-pk="true"/>
    <field name="thruDate" type="date-time"/>

    <relationship type="one" related="co.hotwax.unimail.Party"/>
    <relationship type="one" related="moqui.basic.Enumeration">
        <key-map field-name="roleTypeId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="RoleType" description="Party Role Type"/>
        <moqui.basic.Enumeration enumId="UnimailTenant" enumTypeId="RoleType" description="Retailer Tenant"/>
    </seed-data>
</entity>
```


```xml
<entity entity-name="EmailGatewayConfig" package="co.hotwax.unimail" use="configuration" cache="true">
    <field name="emailGatewayConfigId" type="id" is-pk="true"/>
    <field name="description" type="text-medium"/>
    <field name="sendServiceName" type="text-medium"/>
    <field name="eventServiceName" type="text-medium"/>
</entity>
<entity entity-name="EmailGatewayAuthConfig" package="co.hotwax.unimail" use="configuration" cache="true">
    <field name="emailGatewayAuthConfigId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="emailGatewayConfigId" type="id" not-null="true"/>
    
    <field name="modeEnumId" type="id"/> <!-- Eg: Sandbox / Production -->
    <field name="authTypeEnumId" type="id" not-null="true"/>
    <field name="baseUrl" type="text-medium" not-null="true"/>
    
    <field name="apiKey" type="text-medium" encrypt="true"/>
    <field name="username" type="text-medium"/>
    <field name="password" type="text-medium" encrypt="true"/>
    <field name="clientId" type="text-medium"/>
    <field name="clientSecret" type="text-medium" encrypt="true"/>
    <field name="extraConfigJson" type="text-very-long"/>
    
    <field name="fromDate" type="date-time"/>
    <field name="thruDate" type="date-time"/>
    
    <relationship type="one" related="co.hotwax.unimail.EmailGatewayConfig"/>
    <relationship type="one" related="co.hotwax.unimail.Party" short-alias="tenant">
        <key-map field-name="tenantPartyId"/>
    </relationship>
</entity>

```

## Summary
UniMail offers a unified and provider-agnostic API surface for sending email and tracking user behavior. While the backend behavior varies depending on the configured email gateway (Klaviyo, Iterable, SMTP), the OMS interacts with UniMail through a stable and predictable contract.

This enables the business to switch providers, test new integrations, or send messages from its own SMTP infrastructure without impacting the calling systems.

