# 🔀 CROSS JOIN for Variable Initialization in Inventory Routing SQL

## 📌 Context

In the HotWax Commerce **Order Routing Engine**, the `InventorySourceSelector.sql.ftl` template uses a **`CROSS JOIN`** to initialize session variables that simulate procedural, row-by-row allocation logic in MySQL. These variables make complex inventory assignment possible inside a single SQL statement.

---

## 🧾 SQL Snippet

```sql
cross join (
    select 
        @rn := 0,
        @r := 0,
        @oh := 0,
        @oi := 0,
        @f := 0,
        @ps := 0,
        @s := 0,
        @aq := 0,
        @rtd := 0,
        @fom := 0,
        @foc := 0,
        @fpuim := 0
) as t
```

This injects **a single row** of initialized session variables into the result set. Since it’s a `CROSS JOIN` with one row, it **doesn’t duplicate** or change the number of rows in the result.

---

## 📐 Visualization

```
          Subquery (x)
        +------------------+
        | order_id | prod  |
        |----------|--------|
        | O1       | P1     |
        | O1       | P2     |
        | O2       | P1     |
        +------------------+

                 |
                 | CROSS JOIN with:
                 v

   (SELECT @rn:=0, @aq:=0, @fpuim:='') AS t

                 |
                 v

     Every row now has access to these variables:
     → Row 1 sees @rn = 0, @aq = 0, ...
     → Row 2: @rn incremented, @fpuim modified
```

---

## 📦 Variables and Their Uses

| Variable | Purpose                                                                 | Used In / Logic                              |
| -------- | ----------------------------------------------------------------------- | -------------------------------------------- |
| `@rn`    | Row number                                                              | `@rn := @rn+1` as `row_num`                  |
| `@oh`    | Last `ORDER_ID` seen                                                    | Used to detect order changes                 |
| `@oi`    | Last `ORDER_ITEM_SEQ_ID`                                                | Detects transitions between order items      |
| `@aq`    | Accumulated quantity routed for current order                           | Tracked via `allocated_ord_qty`              |
| `@rtd`   | Quantity allocated in current row                                       | `routed_item_qty` logic                      |
| `@r`     | Flag: Was this row retained?                                            | `@r := case when @rtd > 0 then 1 else 0 end` |
| `@f`     | Facility for current row                                                | Used to update tracking state                |
| `@ps`    | Map: Partial allocations — `orderId-orderItemSeqId:qty`                 | Prevents over-routing                        |
| `@s`     | List of fully allocated items                                           | Helps avoid double assignment                |
| `@fom`   | Facility-Order map — `facilityId-orderId` string                        | Tracks usage of facility in multiple orders  |
| `@foc`   | Cached facility order count                                             | Used in facility limit validation            |
| `@fpuim` | Facility-Product unallocated inventory map — `facilityId-productId:qty` | Adjusts after each allocation                |

---

## 🧠 How Variables Are Used in Row Computation

### `@rtd` — Quantity Routed Per Row

```sql
@rtd := CASE
  WHEN facility has enough stock AND allocation needed
    THEN assign min(inv, qty)
  ELSE 0
END
```

### `@fpuim` — Update Facility-Product Inventory Map

If we routed 5 from WH1 for P1:

```sql
@fpuim := concat(@fpuim, ',WH1-P1:5')
```

Next row sees `WH1-P1` already used and deducts accordingly.

### `@ps` and `@s` — Track Allocations Per Item

* `@ps` = `"O1-00001:5,O1-00002:3"` → partials
* `@s` = `"O1-00001,O1-00002"` → fully allocated

### `@fom` and `@foc` — Facility Order Count

Used to track how many orders a facility is handling.

* Example: `@fom = WH1-O1, WH1-O2`
* Counted via:

```sql
char_length(@fom) - char_length(REPLACE(@fom, f.facility_id, ''))
```

### `@aq` — Accumulated Quantity

When routing across rows of the same order, `@aq` adds the amount routed (`@rtd`).

---

## 📊 Example Data

Say we are routing one order with two items:

| ORDER\_ID | ORDER\_ITEM\_SEQ\_ID | PRODUCT\_ID | ITEM\_QTY |
| --------- | -------------------- | ----------- | --------- |
| O1        | 00001                | P1          | 10        |
| O1        | 00002                | P2          | 5         |

And two facilities WH1 and WH2 have:

| FACILITY\_ID | P1 INV | P2 INV |
| ------------ | ------ | ------ |
| WH1          | 8      | 2      |
| WH2          | 5      | 5      |

Routing logic using these variables ensures:

* First try to allocate from WH1 if enough inventory and under max load.
* If partial, track how much routed (`@ps`), how much left.
* `@rtd` tracks what is routed this row.
* `@fpuim` updated after each routing to adjust remaining stock.

---

## ❓ Clarification Questions You Asked

| Question                                    | Answer                                                                                             |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Does `CROSS JOIN` duplicate rows?           | No. It joins every row from main subquery with **one** row (the variable initializer).             |
| Why not set variables outside SQL?          | Keeping them inside makes the query **self-contained**, portable in the app, and rerunnable as-is. |
| How does each row see updates to variables? | MySQL re-evaluates `@var` expressions row-by-row in order of appearance in SELECT.                 |
| How do we track state across rows?          | Variables like `@ps`, `@s`, `@fpuim`, `@fom` maintain state as comma-delimited strings.            |

---

## ✅ Summary

The `CROSS JOIN` with session variable initialization is a key design used in the SQL logic for inventory brokering:

* Enables row-by-row allocation simulation
* Helps track item fulfillment across multiple facilities
* Makes SQL act more like procedural code
* Essential for implementing complex routing constraints (e.g., capacity limits, split logic, backorders)

---
