## Data Fetch Requests

### Completed Order Items (Sales Orders, DEMO_STORE, Physical Items):

Fetch the following columns:

* `ORDER_ID`
* `ORDER_ITEM_SEQ_ID`
* `PRODUCT_ID`
* `PRODUCT_TYPE_ID`
* `IS_PHYSICAL`
* `IS_DIGITAL`
* `SALES_CHANNEL_ENUM_ID`
* `ORDER_DATE`
* `ENTRY_DATE`
* `STATUS_ID`
* `STATUS_DATETIME`
* `ORDER_TYPE_ID`
* `PRODUCT_STORE_ID`

### Completed Return Items (DEMO_STORE, Ecom Return Channel):

Fetch the following columns:

* `RETURN_ID`
* `ORDER_ID`
* `PRODUCT_STORE_ID`
* `STATUS_DATETIME`
* `ORDER_NAME`
* `FROM_PARTY_ID`
* `RETURN_DATE`
* `ENTRY_DATE`
* `RETURN_CHANNEL_ENUM_ID`

### Orders Completed in October 2023 (Shipping Address):

Fetch:

* `ORDER_ID`
* `CONTACT_MECH_ID` (for shipping address)

### Created Sales Orders:

Fetch the following columns:

* `ORDER_ID`
* `TOTAL_AMOUNT` 
* `PAYMENT_METHOD` (Cash, Mastercard, Visa, PayPal, etc.)
* `SHOPIFY_ORDER_NAME`

### Completed Order Items (July 2023):

Fetch the following columns:

* `ORDER_ID`
* `ORDER_ITEM_SEQ_ID`
* `SHOPIFY_ORDER_ID`
* `SHOPIFY_PRODUCT_ID`

### Physical Items Completed from Warehouse (September 2023):

Fetch all relevant data.

### Physical Items Ordered (September 2023):

Fetch all relevant data.

### Order Status Discrepancies:

* **Approved Orders with Multiple Completed Items:** Find orders where two or more items are complete, but the order remains in "approved" status.
* **Approved Orders with Multiple Canceled Items:** Find orders where two or more items are canceled, but the order remains in "approved" status.

### Order Items in Created Status (Sales Orders):

Fetch the following columns:

* `ORDER_ID`
* `PRODUCT_TYPE_ID`
* `ORDER_LINE_ID`
* `EXTERNAL_ID`
* `SALES_CHANNEL`
* `QUANTITY`
* `ITEM_STATUS`
* `PRODUCT_ID`
* `BILL_CITY`
* `BILL_COUNTRY`
* `BILL_POSTALCODE`
* `BILL_ADDRESS1`
* `BILL_ADDRESS2`
* `SHIP_CITY`
* `SHIP_COUNTRY`
* `SHIP_POSTALCODE`
* `SHIP_ADDRESS1`
* `SHIP_ADDRESS2`

### Additional Data Fetches:

* **Customers Created in June 2023:** Fetch all relevant data.
* **Appeasements in July:** Fetch all relevant data.
* **Returns vs. Appeasements:** Explain the differentiation between returns and appeasements.
* **Return Details:** Fetch the following columns for returns:
    * `RETURN_ID`
    * `ENTRY_DATE`
    * `RETURN_ADJUSTMENT_TYPE_ID`
    * `AMOUNT`
    * `COMMENTS`
    * `ORDER_ID`
    * `ORDER_DATE`
    * `RETURN_DATE`
    * `PRODUCT_STORE_ID`

### Orders Completed (August 2023):

Fetch the following columns:

* `PRODUCT_ID`
* `PRODUCT_TYPE_ID`
* `PRODUCT_STORE_ID`
* `TOTAL_QUANTITY`
* `INTERNAL_NAME`
* `FACILITY_ID`
* `EXTERNAL_ID`
* `FACILITY_TYPE_ID`
* `ORDER_HISTORY_ID`
* `ORDER_ID`
* `ORDER_ITEM_SEQ_ID`
* `SHIP_GROUP_SEQ_ID`

### Inventory and Returns:

* **Inventory Variances (Lost/Damaged):** Fetch product inventory variances with the reason "VAR_LOST" or "VAR_DAMAGED."
* **Orders with Multiple Returns:** Find all orders that have more than one return.
