# 📦 MockGatewaySpec.md

## 🧾 Overview
The **Mock Shipping Gateway** (`NA_LOCAL`) provides a simulated carrier integration for UniShip, enabling developers, testers, and OMS business users to interact with shipping workflows in a controlled, offline environment.

This gateway returns predictable, hardcoded responses for core shipping operations:
- Rate calculation
- Shipping label generation
- Label refund

---

## 🎯 Use Cases

### 1. Developer Integrating OMS with UniShip

#### ✅ Purpose
Enable seamless integration of OMS applications with UniShip REST API.

#### 🔧 Features
- Adheres to `ApiInterfaceServices.xml` contract
- Mock implementation located in: `co.hotwax.nalocal.NaLocalServices`
- Fully compatible with:
  - `get#ShippingRate`
  - `request#ShippingLabels`
  - `refund#ShippingLabels`
- Requires:
  - `shippingGatewayConfigId = NA_LOCAL`
  - `tenantPartyId = ADOC`

#### 🔄 Input/Output Behavior
- Accepts all expected request fields (even if unused)
- Returns consistent mock data:
  - Rates: ground/express
  - Labels: URL + tracking
  - Refund: success response

---

### 2. OMS QA & Testing Team

#### ✅ Purpose
Enable automated and manual testing of OMS workflows dependent on carrier integration.

#### 🧪 Capabilities
- Always returns stable, testable output
- Accepts full request shape for contract verification
- Supports:
  - Regression testing
  - Error handling tests (future: `simulateError` toggle)
- Can be run without internet access
- Logs context inputs via `<log>` actions

#### 🔍 Test Scenarios
- Valid rate + label + refund
- Invalid tenant/gateway IDs
- Edge case testing with minimal package info

---

### 3. OMS Sales / Account Management

#### ✅ Purpose
Provide sales engineers and onboarding teams a reliable mock for demoing shipping functionality.

#### 💼 Scenarios
- Show rate lookup + fulfillment
- Walk through label creation
- Display mock tracking number format: `MOCK123456789`
- Return sample label URL (e.g., `https://mock.example.com/label.pdf`)

---

## ⚙️ Technical Configuration

| Field                         | Value                                                   |
|------------------------------|---------------------------------------------------------|
| `shippingGatewayConfigId`    | `NA_LOCAL`                                              |
| Implementation Namespace     | `co.hotwax.nalocal`                                     |
| Gateway Config Location      | `DemoData.xml`                                          |
| REST Entry                   | `uniship.rest.xml` → `/rest/uniship/shipment/...`       |
| Dispatch Router              | `ShippingServices.xml`                                  |
| Interface Definition         | `ApiInterfaceServices.xml`                              |
| Test Tenant                  | `ADOC`                                                  |
| Auth Key                     | `3f6b5eaf12345678` (via `UserLoginKey`)                 |

---

## 📥 API Reference (Routes)

| REST Path                        | Service Called                                      |
|----------------------------------|------------------------------------------------------|
| `POST /uniship/shipment/rate`   | `ShippingServices.get#ShippingRate`                 |
| `POST /uniship/shipment/label`  | `ShippingServices.request#ShippingLabels`           |
| `POST /uniship/shipment/label/refund` | `ShippingServices.refund#ShippingLabels`     |

---

## 🔮 Future Enhancements

| Feature                  | Description                                              |
|--------------------------|----------------------------------------------------------|
| `simulateError=true`     | Force error response for robustness testing              |
| Delay simulation         | Mimic API/network latency                                 |
| Request echo             | Return full input payload in response for debugging       |
| Conditional rates        | Mock rate varies by zip, country, or package weight       |
| UI Preview               | Embed static label PDF/image in response payload         |

---

Reference:

https://developer.fedex.com/api/en-us/guides/sandboxvirtualization.html
