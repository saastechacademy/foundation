# OFBiz NotNaked Data Model and UI Assignment

This assignment uses the NotNaked demo company to practice the foundational data model patterns from Chapters 1–5 of *The Data Model Resource Book* (party, roles, contact mechanisms, product, inventory, order, shipment). Complete the activities in sequence to experience the same data through the OFBiz UI, Webtools, and XML imports.

> **Important Links:**
> - Party Manager: https://localhost:8443/partymgr/control/findparty
> - Product Store Manager: https://localhost:8443/catalog/control/FindProductStore
> - Catalog Manager: https://localhost:8443/catalog/control/FindCatalog
> - Order Manager: https://localhost:8443/ordermgr/control/orderentry
> - Webtools: https://localhost:8443/webtools

## Part 1: Party and Contact Model (Customers and Staff)
Focus on the Party, Contact Mechanism, and Party Role patterns. Create records through the UI first, then repeat via Webtools and XML.

### Activity 1 – Party Manager (Customer: **Alexis River**)
1) Create a person `Alexis River`; assign `Customer` role; update name to `Alexis J River`.  
2) Add contact data: primary email, billing phone, shipping phone, shipping address, billing address (use the New York flagship address: 123 Broadway, New York, NY 10012).  
3) Set billing and shipping addresses to the same value; change billing purpose to `General correspondence address`.  
4) Expire and replace the email, billing address, and shipping address with updated values.

### Activity 2 – Webtools (Customer: **Jamal Lee**)
Repeat Activity 1 using Webtools: create `Jamal Lee` → update to `Jamal T Lee`; add the same contact set; align billing/shipping; adjust address purpose; expire and recreate contact records. Observe the party profile after changes.

### Activity 3 – Combined Approach (Store Manager: **Priya Desai**)
1) In Party Manager: create `Priya Desai` → update to `Priya K Desai`; assign `Employee` and `Manager` roles; add work email, work phone, shipping and billing addresses (Boston store: 99 Newbury Street, Boston, MA 02116); mark billing/shipping as same; change billing purpose to `General correspondence address`. Add a company credit card.  
2) In Webtools: add a user login for this party and assign a security group with Party Manager access. Verify login access.  
3) Expire and recreate the email and both addresses. Confirm changes in Party Manager and Webtools views.

### Activity 4 – Combined Approach (Warehouse Lead: **Diego Santos**)
1) In Party Manager: create `Diego Santos` → update to `Diego R Santos`; assign `Employee` and `Warehouse Clerk` roles; add work email, phone, and warehouse address (Memphis DC: 1230 E Brooks Road, Memphis, TN 38116). Set address purpose to `Shipping Location`.  
2) In Webtools: create two logins—one in the Order Manager security group and one in the Warehouse application group; verify access for each.  
3) Expire and recreate email and address; confirm in Party Manager.

## Part 2: Company, Store Group, and Product Store
Apply the Organization, Party Role, and Store patterns for NotNaked.

### Activity 1 – Company (UI)
Use Product Store Manager to create the company party:  
- Party ID: `NOTNAKED_INC`  
- Name: `NotNaked Inc`  
- Logo URL: `/resources/uploads/images/notnaked-logo.png`  
- Address: 123 Broadway, New York, NY 10012; Phone: +1-111-222-3333  

### Activity 2 – Company Roles (UI)
Assign roles to `NOTNAKED_INC`: Bill From Vendor, Ship From Vendor, Bill To Customer, Internal Organization, Supplier, Vendor, Supplier Agent.

### Activity 3 – Store Group (UI)
Create store group:  
- Store Group ID: `NN_WEB_GROUP`  
- Name/Description: `NotNaked Web + Stores`

### Activity 4 – Product Store (UI)
Create product store:  
- Store ID: `NN_WEB`  
- Store Name: `NotNaked Omnichannel Store`  
- Primary Store Group ID: `NN_WEB_GROUP`  
- Company: `NOTNAKED_INC`  
- Inventory Policy: `Non-reserving`  
- Locale: `English (US)`  
- Currency: `USD`  
- Sales Channel: `Web Sales`  
- Approvals: Invoice/Order approval `Automatic`  
Verify via Product Store screen.

### Activity 5 – Webtools Recreation
Reset the local OFBiz database, then recreate Activities 1–4 using Webtools. Verify via Product Store and Party screens.

### Activity 6 – XML Load
Reset the database; prepare XML for company, roles, store group, and product store; load via Webtools; confirm via admin screens.

## Part 3: Catalog and Product Model
Model categories, features, virtual/variant products, and promotions reflecting NotNaked’s assortment (finished goods, marketing bundles, digital gift cards).

### Activity 1 – Create Catalog (UI)
Create catalog `GenZ Essentials Catalog`. Define categories:  
- Browse Root  
  - Tops (T-Shirts, Hoodies)  
  - Bottoms (Jeans, Joggers)  
  - Outerwear (Puffer, Raincoat)  
  - Accessories (Caps, Bags)  
  - Digital (Gift Cards)  
  - Promotions  
Verify in Catalog Manager.

### Activity 2 – Features and Products (UI)
1) Features: Sizes XS, S, M, L, XL; Colors Black, White, Forest, Terracotta.  
2) Virtual + Variant Products:  
   - Tops > T-Shirts: `NN-TEE-1` (Black/White, sizes XS–XL); `NN-TEE-2` (Forest/Terracotta, sizes S–XL)  
   - Tops > Hoodies: `NN-HOOD-1` (Black/Forest, sizes S–XL)  
   - Bottoms > Jeans: `NN-JEAN-1` (Black, sizes 28–36); `NN-JEAN-2` (Indigo, sizes 28–36)  
   - Outerwear > Puffer: `NN-PUFF-1` (Black/White, sizes S–XL)  
   - Accessories > Caps: `NN-CAP-1` (Black/Forest, one size)  
   - Digital > Gift Cards: `NN-GC-50`, `NN-GC-100`  
Create variants for each feature combination where applicable.

### Activity 3 – Promotions (UI)
Create a promotion targeting new customers: 15% off virtual products `NN-TEE-1` (all variants) and `NN-PUFF-1` (all variants); include a gift-with-purchase rule for `NN-GC-50` when cart value > $200. Attach to the Promotions category.

### Activity 4 – Webtools Recreation
Reset DB; recreate catalog, categories, features, products, and promotion via Webtools. Verify in Catalog Manager and Promotion screens.

### Activity 5 – XML Load
Reset DB; prepare XML for catalog, categories, feature types/values, products/variants, and promotion rules; import via Webtools; verify in admin screens.

## Part 4: Facilities and Inventory Model
Map facilities for warehouses and flagship stores; practice inventory items and receipts. Keep products as **finished goods only** (no serialization, no lot tracking) and always relate Product ↔ Facility via `ProductFacility` before creating inventory.

**Inventory configuration quick tips (set before transacting inventory):**
- Facility defaults: set `defaultInventoryItemTypeId=NON_SERIAL_INV_ITEM`, `defaultDaysToShip` per SLA, and add contact mechs for ship-from.  
- Product Store: ensure `inventoryFacilityId` is set, `oneInventoryFacility` = `Y` if using a single DC, `checkInventory` = `Y`, `reserveInventory` = `Y`, and `reserveOrderEnumId` = `INVRO_FIFO_REC`.  
- ProductFacility: leave `requireInventory/requireLot/requireSerial` blank for simple goods; set `minimumStock`, `reorderQuantity`, `daysToShip`.  
- FacilityLocation/ProductFacilityLocation: define at least one bulk + one pick location to keep UI transactions simple.  
- Reference docs: `project-ideas/oms/Inventory.md`, `project-ideas/oms/ProductFacility.md`, `project-ideas/oms/Facility.md`, and `project-ideas/oms/Shipment.md` for deeper data model context.

### Activity 1 – Facilities (UI)
Create facilities for warehouses (set `defaultInventoryItemTypeId=NON_SERIAL_INV_ITEM`, and `defaultDaysToShip` per DC SLA):  
- `NN-FC-MEM` – NotNaked Fulfillment Center – Memphis – 1230 E Brooks Road, Memphis, TN 38116  
- `NN-FC-IND` – Indianapolis – 5402 W 76th Street, Indianapolis, IN 46268  
- `NN-FC-COL` – Columbus – 2777 Rickenbacker Parkway W, Columbus, OH 43217  
- `NN-FC-SAV` – Savannah – 1001 Gulfstream Road, Savannah, GA 31408  
Create retail stores as facilities: `NN-STORE-NY` (SoHo), `NN-STORE-BOS`, `NN-STORE-CHI`, `NN-STORE-AUS` using the addresses in the intro document.  
For one warehouse (e.g., `NN-FC-MEM`):  
1) Add contact mechs: create postal address, shipping phone, and a warehouse email.  
2) Assign purposes: set postal to `SHIPPING_LOCATION` and `SHIP_ORIG_LOCATION`; set phone to `PHONE_SHIPPING`; set email to `PRIMARY_EMAIL`.  
3) Define locations: create one bulk location and one pick location using a consistent code scheme (e.g., `AREA01-BULK-01` for bulk, `AREA01-PICK-01` for pick).  
4) Verify: ensure the facility shows the contact mechs with purposes, and the two locations are visible for later ProductFacilityLocation mapping.

### Activity 2 – Inventory Items (UI)
1) **ProductFacility setup (per facility, simple finished goods):** For `NN-TEE-1`, `NN-HOOD-1`, `NN-JEAN-1`, create `ProductFacility` rows in `NN-FC-MEM`, `NN-STORE-NY`, `NN-STORE-BOS` (leave `requireInventory/requireLot/requireSerial` blank). Populate `minimumStock`, `reorderQuantity`, `daysToShip` using the demo pattern (ex: `minimumStock=5`, `reorderQuantity=20`, `daysToShip=1`).  
2) **ProductFacilityLocation:** Map each product to one bulk and one pick location (if configured in Activity 1) mirroring demo rows with `moveQuantity` values to replenish pick from bulk.  
3) **Receive inventory (non-serialized, non-lot):** Receive bulk into `NN-FC-MEM` for the above products/variants; verify `InventoryItemType` = `NON_SERIAL_INV_ITEM`, set `unitCost`, and add `InventoryItemDetail` with `availableToPromiseDiff` and `quantityOnHandDiff` (demo uses `500/5/15` etc.).  
4) **Transfer to stores:** Issue an inventory transfer from `NN-FC-MEM` to `NN-STORE-NY` and `NN-STORE-BOS` for starter quantities (keep items non-serialized/non-lot). Confirm ATP/QOH updates per facility and that Product ↔ Facility linkage exists for each receiving site.

### Activity 3 – Webtools Recreation
Reset DB; recreate the `ProductFacility` links, location mappings, receipts, and transfers via Webtools; verify Inventory Items show `NON_SERIAL_INV_ITEM` and correct facility balances.

### Activity 4 – XML Load
Reset DB; prepare XML for facilities, `ProductFacility` rows, `ProductFacilityLocation`, and non-serialized inventory items/receipts/transfers; load via Webtools; confirm facility and inventory records.


## Part 5: Orders, Shipments, and Fulfillment Flows
Practice order lifecycle and shipment patterns (BOPIS/BORIS and ship-from-warehouse).

### Activity 1 – Create Web Order (UI)
Order ID `NN1000`; customer `Alexis River`; two items (e.g., `NN-TEE-1` variant and `NN-JEAN-1` variant); shipping address: 123 Broadway, New York, NY 10012; shipping method UPS Ground; billing via Visa (4111 1111 1111 1111).

### Activity 2 – Approve and Pack (UI)
Order ID `NN1001`; status Approved; items Approved; ship-from `NN-FC-MEM`; shipping method UPS 2nd Day; billing Discover; create shipment record `NN-SHP-1001` and mark as Packed.

### Activity 3 – BOPIS Flow (UI)
Create order `NN1002` for `Jamal Lee` with pickup facility `NN-STORE-NY`; authorize payment by AMEX; mark order ready for pickup; complete fulfillment and payment capture on delivery.

### Activity 4 – BORIS Flow (UI)
Create order `NN1003` shipped from `NN-FC-IND`; after delivery, process an in-store return at `NN-STORE-BOS` for one line; issue refund to original card; confirm return inventory goes to `NN-STORE-BOS`.

### Activity 5 – Webtools Recreation
Reset DB; recreate Activities 1–4 via Webtools; verify orders, shipments, returns in admin screens.

### Activity 6 – XML Load
Reset DB; prepare XML for orders, payments, shipments, and return records from Activities 1–4; load via Webtools; confirm in Order and Shipment screens.

---

**Completion Checklist**
- Party, contact, and role records created via UI/Webtools/XML.  
- Company, store group, and product store set for `NotNaked Inc`.  
- Catalog (categories, features, products, promotion) created and verified.  
- Facilities and inventory items present for DCs and stores.  
- Orders, shipments, BOPIS/BORIS flows executed and visible in admin screens.  
