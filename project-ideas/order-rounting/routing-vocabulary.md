# Order Routing Vocabulary (HotWax Commerce OMS)

This document defines the **controlled vocabulary** used by routing sample representations (Case Cards and Feature Vectors). It is intended to keep language consistent across:
- business-facing summaries (embedding-friendly Case Cards)
- deterministic structured extraction (Feature Vectors)

This vocabulary is curated from:
- `popular-omnichannel-configurations.md` (business concerns and common objectives)
- `order-lifecycle.md` (OMS lifecycle + parking dictionary)
- `order-routing.md` and `order-routing-technical.md` (routing hierarchy, mental model, JSON mapping)
- `order-routing-type-and-setup-data-fields.md` and `assets/order-routing-group.schema.json` (field/enumeration identifiers)

If a concept is not supported by sample evidence, representations must use `unknown` rather than guessing.

---

## 1) Primary Goal Enum (Case Cards + Feature Vectors)

Use exactly one of:
- `protect_store_ops`
- `reduce_markdowns`
- `reduce_splits`
- `meet_sla`
- `reduce_shipping_cost`
- `reduce_rejections`
- `handle_exceptions`
- `product_specific_fulfillment`
- `mixed`

Guidance:
- Use `mixed` when the sample clearly covers multiple concerns (e.g., SLA + splits + exceptions).
- Use `handle_exceptions` when the sample is primarily about parking/queues, retries, or unfillable handling.

---

## 2) Business Concern Phrases (preferred wording)

Prefer the following phrases (verbatim) for Case Card `businessConcerns[]` and tags where applicable:

1. Protect in-store customers while selling online
   - Set safety stock at stores
   - Fulfill new launches from warehouses first
   - Prioritize locations with broken styles

2. Handle product-specific fulfillment needs
   - Route based on product

3. Reduce markdowns
   - Ship slow-moving inventory first

4. Prevent stores from being overwhelmed by online orders
   - Use stores selectively for fulfillment
   - Apply order limits per store
   - Apply lower routing priority for high-traffic stores
   - Make stores offline on demand

5. Handle high-priority orders and tighter SLAs
   - Route based on order priority and SLA
   - Prioritize fulfillment of urgent orders in-store

6. Reduce order splits
   - Limit splits to orders that require them
   - Avoid splitting low-value orders
   - Prevent splits for kits and gift with purchase

7. Reduce order rejections and overselling
   - Global inventory thresholds
   - Fulfill from stores with sufficient inventory

8. Handle exceptions
   - Allow partial rejection
   - Apply collateral rejection
   - Auto-reroute on store rejection
   - Use fallback fulfillment locations

---

## 3) OMS Glossary (terms used in summaries)

Use these terms consistently:

- **Brokering Run**: the scheduled routing job that processes approved orders (see also “Order Routing Group”).
- **Brokering Queue**: the parking/virtual facility holding standard approved orders waiting for routing.
- **Parking / Queue**: a virtual facility used to hold orders in a defined state (e.g., Backorder Parking, Unfillable Parking).
- **Rejected Queue**: parking for orders/items rejected by an assigned facility so routing can retry.
- **Unfillable Parking**: parking for orders/items with no allocatable inventory found; may start an auto-cancel timer.
- **Unfillable Hold Parking**: parking used to prevent auto-cancel when replenishment is expected.
- **General Ops Parking**: parking for orders that require no further action.
- **Pre-Order Parking / Backorder Parking**: parkings for orders awaiting release date or replenishment.

If a Case Card references a parking/queue, it must be evidenced by `facilityId` order filters and/or `ORA_MV_TO_QUEUE` actions in the sample.

---

## 4) Routing Structure Vocabulary (business ↔ JSON)

Use these mappings consistently:

- **Brokering Run / Schedule** → routing group (`_entity: "orderRoutingGroup"`)
- **Routing Rule / Batch** → routing (`_entity: "orderRouting"`, in `routings[]`)
- **Inventory Rule / Waterfall step** → rule (`_entity: "orderRoutingRule"`, in `rules[]`)

Where logic lives:
- Order selection + prioritization → `orderFilters[]`
- Facility selection + ranking → `inventoryFilters[]`
- Outcomes / fallbacks → `actions[]`

---

## 5) Tag Lexicon (recommended tags and evidence signals)

Use these tags only when evidence exists in the sample:

- `distance cap`: `inventoryFilters` include `fieldName: "distance"` with an operator like `less-equals` and a `measurementSystem` filter.
- `brokering safety stocks`: `inventoryFilters` include `fieldName: "brokeringSafetyStock"`.
- `unfillable parking`: `ORA_MV_TO_QUEUE` action value or `facilityId` filter references `UNFILLABLE_PARKING`.
- `backorder parking`: `facilityId` filter or `ORA_MV_TO_QUEUE` references `BACKORDER_PARKING`.
- `pre-order parking`: `facilityId` filter or `ORA_MV_TO_QUEUE` references `PRE_ORDER_PARKING`.
- `rejected queue retry`: `facilityId` filter includes `REJECTED_ITM_PARKING` and the schedule indicates frequent retries.
- `auto-cancel`: actions include `ORA_AUTO_CANCEL_DAYS` and/or `ORA_RM_CANCEL_DATE`.
- `warehouse first`: a facility-group eligibility filter for warehouses appears before a store/broader rule in a waterfall (or the sample explicitly uses warehouse-only eligibility).
- `ship from store`: a facility-group eligibility filter includes retail/store groups (org-specific naming; must be evidenced).
- `SLA`: order filters include `shipmentMethodTypeId` and/or sort-by `deliveryDays`/`priority`.
- `fallback`: rules include `ORA_NEXT_RULE` and/or terminal `ORA_MV_TO_QUEUE`.

If the meaning is org-specific (e.g., `shipmentThreshold`, `splitOrderItemGroup`), treat it as a signal and avoid over-interpreting it in summaries.

