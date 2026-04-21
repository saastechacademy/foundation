# Order Routing Microservice — Why, What, and How

## Why This Exists
- Need dynamic, rules-driven assignment of orders to fulfillment locations without baking logic into the order system of record.
- Improve fulfillment SLAs and cost by brokering across stores/DCs/queues based on availability, thresholds, and routing actions.
- Keep routing logic pluggable so multiple OMS/backends can consume it via callbacks.

## What It Does
- Hosts routing configurations (groups, routings, rules, filters, actions) and executes brokering runs.
- Produces facility allocation decisions for order items/ship groups and hands them off to the OMS for execution.
- Tracks run/batch history for audit/ops visibility.

## Scope & Responsibilities
- **Planning & setup**: define routing groups, routings, rules (order filters, inventory filters), actions (move to queue, auto-cancel, ship method suggestions), sequences, and schedules.
- **Execution**: run routing groups (manual/scheduled); evaluate rules against orders/ship groups; build facility allocation payloads; invoke OMS callbacks to apply allocations/reservations.
- **Auditability**: persist runs/batches with counts, errors, and comments; log applied rule and suggested ship methods.
- **Extensibility**: rule conditions/actions driven by enums; adapters via service callbacks.

## What It Is Not
- Not the order or inventory system of record; does not own OrderHeader/OrderItem/OrderItemShipGroup/InventoryItem.
- Does not apply allocations/reservations directly; relies on OMS services to mutate SoR.
- Does not manage identity/auth beyond using platform authentication.

## Owned Entities (OrderRouting component)
- `OrderRoutingGroup`: grouping + schedule hook (`jobName`, `productStoreId`, sequence).
- `OrderRouting`: routing definitions under a group; status, sequence.
- `OrderFilterCondition`: order-level filters/order-by for routing.
- `OrderRoutingRule`: rule metadata; status, assignment enum.
- `OrderRoutingRuleInvCond`: inventory filters for a rule.
- `OrderRoutingRuleAction`: actions (e.g., move to queue, auto-cancel, ship method hints).
- `OrderRoutingRun`: run execution record (start/end, result, counts, errors).
- `OrderRoutingBatch`: batch container for runs.
- `UserSession` (co.hotwax.user): test-drive/by-store session gating.
- View entities for reporting (OrderRoutingGroupJobRun, OrderRoutingGroupBatchRun).

## Referenced (Not Owned)
- Orders: `OrderHeader`, `OrderItem`, `OrderItemShipGroup` (SoR).
- Facilities/ProductStore: `Facility`, `FacilityType`, `ProductStore`.
- Shipping: `CarrierShipmentMethod`.
- Config/Framework: `StatusItem`, `Enumeration`, `ServiceJob`/`ServiceJobRun`, `ProductStoreFacilityGroup`, `OrderFacilityChange`.
- Queues: virtual facility IDs used as order queues when rules move unfillable items.

## OMS Callbacks (Required to “do the work”)
- Facility allocation + reservation is performed by OMS: `co.hotwax.oms.impl.OrderReservationServices.process#OrderFacilityAllocation`.
- Routing engine sends `facilityAllocation` payloads (facilityId, items, comments, rule/group/run IDs, changeReasonEnumId, suggested ship method, queue/auto-cancel hints).
- Errors from callbacks are logged/cleared in routing to keep routing concerns separate from SoR mutations.

## How Routing Runs Work (Conceptual)
- Validate routing group ↔ product store.
- Enforce semaphore per productStore (one run at a time).
- Fetch active routings (status `ROUTING_ACTIVE`) by sequence.
- For each rule: evaluate order filters/inventory filters; decide allocations; build actions (queue moves, auto-cancel date changes, ship method suggestions); stop or continue based on results.
- Invoke OMS callback to apply allocations/reservations.
- Record run/batch metrics (attempted vs brokered items, comments, errors).

## Microservice Framing
- Clear bounded context with owned schema and run history.
- References SoR order/inventory/facility data; does not own or directly mutate them.
- Integrates via callbacks for state changes, making it deployable alongside different OMS backends.

## Non-Functional Expectations
- Idempotent runs per routing group with semaphore to avoid concurrent conflicts.
- Auditable (runs/batches logged with outcomes and errors).
- Pluggable schedules via ServiceJob; supports manual “run now.”

## Integration Notes for OMS
- Expose callback(s) for facility allocation/reservation; honor virtual facility (queue) moves and auto-cancel hints.
- Expect allocation payloads to include rule/group/run IDs for traceability.
- Routing engine should not bypass OMS rules for SoR updates; OMS owns OrderItemShipGroup/InvRes/InventoryItemDetail changes.
