# Developer Notes – process#ShopifyOrders Service

Below are the functional notes describing how each part of the service processes Shopify REST + GraphQL order fields and stores them into the OMS (OFBiz). 

## 1. Order Existence Check

**Purpose:** Prevent duplicate order creation.  
**Logic:**

- Check `OrderIdentification` for `SHOPIFY_ORD_ID = legacyResourceId`.
- If count > 0 → Order already exists → skip creation logic.

## 2. Shopify Config & ProductStore Lookup

**Purpose:** Determine `productStoreId` and inventory facilities.  
**Logic:**

- Fetch `ShopifyShopAndConfig` using `shopifyConfigId = 10010`.
- Fetch `ProductStore` using `productStoreId`.
- If not found → log error and exit.

## 3. Tags

**Purpose:** Skip order import if tags match forbidden tags.  
**Steps:**

1. Extract tags from Shopify REST → clean HTML comments/tags.
2. Convert comma-separated string → list.
3. Load skip tags from:
ShopifyServiceConfig.${productStoreId}.skip.import.tags
(SystemProperty)
4. If intersection exists between `orderTags` and `skipTags` → `skipOrder = true`.
5. If no skip tags matched → proceed.

---

## 4. Order Base Fields

**Mapped as:**

- `legacyResourceId` → `orders.externalId`
- `totalPriceSet.shopMoney.amount` → `orders.grandTotal`
- `totalPriceSet.shopMoney.currencyCode` → `orders.currencyUomId`
- `orderTypeId` always `"SALES_ORDER"`

---

## 5. Sales Channel Mapping

**Purpose:** Map Shopify `sourceName` to OMS sales channel.  
**Logic:**

- Call `ShopifyMappingWorker.getShopifyTypeMappedValue()`
- If mapping missing:
  - Set `salesChannelEnumId = UNKNWN_SALES_CHANNEL`
  - Create a `CommunicationEvent` note to record fallback.

## 6. Shipping Address + POS Order Classification

**Purpose:** Detect POS orders & mixed-cart orders.

 **Definitions**:

**ShippingAddress empty** → order picked up in store.

#### POS Completed Order:
- No shipping address  
- AND sales channel = `POS_SALES_CHANNEL`

#### Mixed Cart POS Order:
- Shipping address exists  
- AND `displayFulfillmentStatus = PARTIALLY_FULFILLED`  
- AND sales channel = `POS`

Used to determine facility assignment.

## 7. Default Facility & Location Facility

** Default Facility:**
If:
- `reserveInventory == 'Y'`  
- and `inventoryFacilityId` exists  

→ set `defaultFacility`.

### Retail Location Mapping:
- If `retailLocation.legacyResourceId` exists  
- AND order is **not** a `"sendsale"`  
→ extract `locationId`.

### Final Facility Assignment:
For POS Completed or Mixed Cart orders:

- Map `locationId` → `facilityId` via  
`ShopifyMappingWorker.getFacilityId()`
- If mapping fails → fallback to `defaultFacility`.
- Else if locationId is not present or not mixedCart or PosCompleted → `facilityId = "_NA_"`.

---

## 8. Order Identification Setup

Creates multiple identifications:

- `SHOPIFY_ORD_ID` → `legacyResourceId`
- `SHOPIFY_ORD_NAME` → Shopify order name  
(More can be added if needed)

Stored in:  
`orders.identifications`

---

## 9. Order Contact Details

**Purpose:** Store order email & phone as ContactMechs.  
**Logic:**

- Build map:  
`[email: email, phone: phone]`
- Call `map#OrderContactMech`
- Output stored in:  
`orders.contactMechs`

---

## 10. Order Attributes (Custom Attributes)

**Purpose:** Capture Shopify custom data as OrderAttributes.  
**Logic:**

- For each `customAttributes[]`:
- Trim keys to 59 chars
- Trim values to 999 chars
- Add to `orders.attributes`

**Staff Member Mapping:**

If `staffMember.id` exists:

Add attribute:

- `attrName = shopify_user_id`
- `attrValue = staffMember.id`

---

## 11. Create OrderHeader

**Final OMS Order Creation:**

- Log the final `orders` map.
- Call `create#OrderHeader`.
- Receive `orderId`.

---

