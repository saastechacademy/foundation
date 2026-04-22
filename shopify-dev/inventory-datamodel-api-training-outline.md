# Shopify Inventory Management on Shopify Platform: Training Coverage Checklist

Audience: Mid-level developer with supply chain, OMS, ERP, and general Shopify knowledge.

Goal: Ensure the developer understands Shopify inventory concepts and APIs well enough to design Shopify-side inventory flows for OMS/ERP integration, where OMS is the source of truth and Shopify stays in sync with the rest of the stack.

Use of this document: Workshop coverage checklist for trainer, program designer, and developer. This is not the training material itself.

## Core framing

- OMS is the primary operational system for inventory management.
- Shopify is a downstream commerce platform that must reflect the correct inventory state.
- The developer must understand Shopify's inventory model and APIs well enough to design reliable sync behavior from OMS/ERP into Shopify.
- Training should stay focused on Shopify inventory concepts, Shopify inventory APIs, and how those concepts affect integration design.

## 1. Shopify inventory domain model

- Cover how Shopify models inventory and why this model matters for OMS-led integrations.
- Cover the relationship: ProductVariant -> InventoryItem.
- Cover the relationship: InventoryItem -> InventoryLevel.
- Cover the relationship: Location -> InventoryLevels.
- Cover that inventory is tracked per item, per location, not as one global quantity.
- Cover that a developer designing integrations must understand which Shopify IDs must be stored and reused.
- Call out inline: integration design must preserve `inventoryItemId` and `locationId` for reliable downstream updates.
- References:
  - [Manage inventory quantities and states](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps/manage-quantities-states)
  - [inventoryItem query](https://shopify.dev/docs/api/admin-graphql/latest/queries/inventoryItem)
  - [inventoryLevel query](https://shopify.dev/docs/api/admin-graphql/latest/queries/inventoryLevel)
  - [location query](https://shopify.dev/docs/api/admin-graphql/latest/queries/location)
  - [productVariants query](https://shopify.dev/docs/api/admin-graphql/latest/queries/productVariants#example-2--fetching-inventory-info-for-product-variants)
- Assignment:
  - Identify the minimum Shopify inventory objects and IDs that an OMS-to-Shopify integration must know in order to read and update inventory correctly.

## 2. Reading inventory from Shopify

- Cover how to read inventory for a single item across locations.
- Cover how to read inventory for a location across many items.
- Cover how to read inventory starting from product variant context.
- Cover when to use `inventoryItem`, `inventoryLevel`, `location`, and `productVariants` queries.
- Cover that solution design often starts with read patterns before write patterns.
- Call out inline: the developer should understand what Shopify can expose back to OMS/integration services for validation and reconciliation.
- References:
  - [inventoryItem query](https://shopify.dev/docs/api/admin-graphql/latest/queries/inventoryItem)
  - [inventoryLevel query](https://shopify.dev/docs/api/admin-graphql/latest/queries/inventoryLevel)
  - [location query](https://shopify.dev/docs/api/admin-graphql/latest/queries/location)
  - [productVariants query](https://shopify.dev/docs/api/admin-graphql/latest/queries/productVariants#example-2--fetching-inventory-info-for-product-variants)
- Assignment:
  - Review which Shopify read path is best for each scenario: item-centric view, location-centric view, and variant-centric view.

## 3. Inventory quantities and quantity states

- Cover that Shopify inventory levels hold quantities by state, not just a single stock number.
- Cover the purpose of key states such as `available`, `incoming`, `on_hand`, `committed`, `reserved`, and `damaged`.
- Cover which states matter most when Shopify must reflect OMS-driven inventory decisions.
- Cover the difference between "inventory visible for selling" and broader operational inventory state.
- Call out inline: the developer must understand which Shopify state is being synchronized from OMS and which states are only relevant inside Shopify workflows.
- References:
  - [Manage inventory quantities and states](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps/manage-quantities-states)
- Assignment:
  - Identify which quantity states should be understood first when designing an OMS-to-Shopify inventory sync.

## 4. Inventory adjustments vs inventory sets

- Cover the difference between delta-based inventory updates and absolute inventory updates.
- Cover when to use `inventoryAdjustQuantities`.
- Cover when to use `inventorySetQuantities`.
- Cover why this distinction matters in an OMS-led architecture.
- Cover how `compareQuantity` affects safe updates.
- Cover why a developer must understand whether Shopify is being incrementally adjusted or explicitly aligned to OMS quantity.
- Call out inline: this is a design-critical topic because wrong write semantics create drift between OMS and Shopify.
- References:
  - [Manage inventory quantities and states](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps/manage-quantities-states)
  - [inventoryAdjustQuantities mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryAdjustQuantities)
  - [inventorySetQuantities mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventorySetQuantities)
- Assignment:
  - For each sample business event, decide whether Shopify should receive an adjustment-style update or a set-style update.

## 5. Safe write behavior and inventory update intent

- Cover the role of audit-related fields such as reason and reference document metadata.
- Cover why integrations should avoid unnecessary ID lookups during write operations.
- Call out inline: the design should make it clear what business event caused a Shopify inventory change.
- References:
  - [inventoryAdjustQuantities mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryAdjustQuantities)
  - [inventorySetQuantities mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventorySetQuantities)
- Assignment:
  - Identify what context from OMS should accompany a Shopify inventory write so the change can be understood and traced later.

## 6. Shopify locations as part of integration design

- Cover how Shopify locations affect inventory visibility and quantity storage.
- Cover why location mapping is required for OMS-to-Shopify design.
- Cover that incorrect location mapping can produce correct total inventory but wrong sellable inventory distribution.
- Cover how location-aware inventory reads and writes influence solution design.
- Call out inline: the developer must think in terms of item plus location, not item alone.
- References:
  - [location query](https://shopify.dev/docs/api/admin-graphql/latest/queries/location)
  - [inventoryLevel query](https://shopify.dev/docs/api/admin-graphql/latest/queries/inventoryLevel)
- Assignment:
  - Identify what location-mapping decisions must be made before an OMS can synchronize inventory correctly into Shopify.

## 7. Inventory transfers in Shopify

- Cover what an `InventoryTransfer` represents in Shopify.
- Cover the transfer lifecycle and statuses at a conceptual level.
- Cover origin location and destination location behavior.
- Cover line items within a transfer.
- Cover why transfer objects matter even when the operational movement may be initiated in OMS.
- Call out inline: the developer should understand when Shopify transfer concepts are relevant to mirrored operational flows from external systems.
- References:
  - [InventoryTransfer object](https://shopify.dev/docs/api/admin-graphql/latest/objects/InventoryTransfer)
  - [inventoryTransferCreate mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreate)
  - [inventoryTransferCreateAsReadyToShip mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreateAsReadyToShip)
  - [inventoryTransferSetItems mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferSetItems)
  - [InventoryTransferStatus enum](https://shopify.dev/docs/api/admin-graphql/latest/enums/InventoryTransferStatus)
- Assignment:
  - Identify when a Shopify transfer should be modeled explicitly versus when Shopify only needs the resulting inventory state.

## 8. Shipments and receiving in Shopify

- Cover how shipments relate to inventory transfers in Shopify.
- Cover the shipment lifecycle at a conceptual level.
- Cover what receiving means in Shopify inventory terms.
- Cover how partial receiving changes inventory state.
- Cover why shipment and receiving concepts matter for solution design even if OMS owns the operational process.
- Call out inline: the developer should understand whether Shopify is a passive recipient of final quantities or a modeled participant in movement workflows.
- References:
  - [inventoryShipmentCreate mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreate)
  - [inventoryShipmentCreateInTransit mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreateInTransit)
  - [inventoryShipmentReceive mutation](https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentReceive)
  - [InventoryShipmentStatus enum](https://shopify.dev/docs/api/admin-graphql/latest/enums/InventoryShipmentStatus)
  - [Inventory shipment timestamp fields](https://shopify.dev/changelog/inventory-shipment-timestamp-fields)
- Assignment:
  - Review how receiving events in OMS could map to shipment-related inventory state changes in Shopify.

## 9. Designing Shopify-side inventory flows in an OMS-led architecture

- Cover how to think about Shopify as downstream from OMS.
- Cover how Shopify inventory reads support design validation.
- Cover how Shopify inventory writes should reflect OMS intent.
- Cover how quantity state, location mapping, and write semantics combine in a sync design.
- Cover where transfer and receiving concepts may or may not be represented explicitly in Shopify.
- Call out inline: the goal is not just API familiarity, but correct Shopify-side flow design.
- References:
  - [Manage inventory quantities and states](https://shopify.dev/docs/apps/build/orders-fulfillment/inventory-management-apps/manage-quantities-states)
  - Reuse references from the sections above as needed during the workshop.
- Assignment:
  - For each core inventory workflow, explain what Shopify must know, what OMS remains responsible for, and which Shopify inventory APIs are relevant.

## 10. End-of-training implementation assignments

- Include one hands-on exercise focused on reading current Shopify inventory model and quantity state for a selected SKU across locations.
- Include one hands-on exercise focused on choosing and using the correct inventory write pattern in Shopify for an OMS-driven update.
- Include one end-to-end exercise where the developer maps an OMS inventory event to the correct Shopify inventory objects, quantity state, and write API.
- Include one end-to-end exercise where the developer explains whether transfer/shipment concepts should be represented directly in Shopify or only reflected as final inventory state.

## Review checkpoint

- The developer can explain the Shopify inventory domain model without confusing variant, item, level, and location.
- The developer can identify which Shopify inventory query path fits a given design problem.
- The developer can distinguish quantity states and explain why they matter.
- The developer can decide between adjustment-based and set-based writes.
- The developer can explain how location mapping affects integration design.
- The developer can describe how transfers and receiving relate to Shopify inventory modeling.
- The developer can design Shopify-side inventory flows that stay aligned with an OMS-led architecture.
