#### `findOrCreateOrderItemShipGroup`

#### **Purpose**

This function is a utility method that:
1. Retrieves the most recently created `OrderItemShipGroup` for a given `orderId` and `facilityId`.
2. Creates a new `OrderItemShipGroup` record if no matching records exist.
3. Optimizes repeated calls within a short timeframe by leveraging Moqui's entity caching system.

---

#### **Inputs**

| **Parameter**      | **Type**   | **Description**                                             |
|---------------------|------------|-------------------------------------------------------------|
| `orderId`           | `String`   | The ID of the order to which the ship group belongs.         |
| `facilityId`        | `String`   | The ID of the facility associated with the ship group.       |

---

#### **Outputs**

| **Field**              | **Type**     | **Description**                                                  |
|-------------------------|--------------|------------------------------------------------------------------|
| `orderItemShipGroup`    | `Map`        | The `OrderItemShipGroup` record that was either found or created. |

---

#### **Steps**

1. **Query Database**:
    - If the cache misses, query the `OrderItemShipGroup` entity to find records matching `orderId` and `facilityId`.
    - Sort by `shipGroupSeqId` in descending order to get the most recently created record.

2. **Create New Record**:
    - If no matching record is found, generate a new `shipGroupSeqId` using `ec.nextSeqId`.
    - Create a new `OrderItemShipGroup` record with the given `orderId` and `facilityId`.

#### **Performance Optimization**

- **Entity Cache**:
    - Use Moqui’s built-in caching to avoid repetitive database queries for the same `orderId` and `facilityId`.
    - Cached records are automatically refreshed when underlying data changes.

