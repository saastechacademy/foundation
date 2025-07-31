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

## Summary
UniMail offers a unified and provider-agnostic API surface for sending email and tracking user behavior. While the backend behavior varies depending on the configured email gateway (Klaviyo, Iterable, SMTP), the OMS interacts with UniMail through a stable and predictable contract.

This enables the business to switch providers, test new integrations, or send messages from its own SMTP infrastructure without impacting the calling systems.
