# Recommendations for `<log>` Messages

To ensure `<log>` messages are **consistent**, **insightful**, and **easily analyzable** 

---

## **General Pattern for Log Messages**

### **Pattern Template**

```plaintext
[Entity] [Context] - [Action/Outcome/Issue]
```

- **Entity**: The primary entity involved (e.g., `Order`, `Shipment`, `Asset`, `Inventory`).
- **Context**: Dynamic data providing specific identifiers (e.g., IDs, statuses, totals).
- **Action/Outcome/Issue**: Description of the operation, outcome, or issue.

---

## **Examples of Refactored Log Messages**

### 1. **Validation Logs**

```xml
<log message="Address [Validated: ${validateCount}] - Completed in ${elapsedTime} minutes"/>
```

```xml
<log message="Order [ID: ${orderId}] - Validation failed for missing productId"/>
```

### 2. **Error Logs**

```xml
<log level="error" message="ShippingGatewayConfig [ID: ${shippingGatewayConfigId}] - Missing refundLabelsServiceName, skipping address validation"/>
```

```xml
<log level="error" message="Shipment [ID: ${shipmentId}] - Could not find associated RouteSegment"/>
```

```xml
<log level="error" message="Inventory [Product ID: ${productId}, Facility: ${facilityId}] - Insufficient stock"/>
```

### 3. **Asset Reservation Logs**

```xml
<log level="warn" message="AssetReservation [ID: ${assetReservationId}, OrderItem: ${orderItem.orderId}:${orderItem.orderItemSeqId}, Facility: ${asset.facilityId}] - Invalid reservation"/>
```

```xml
<log level="warn" message="Asset [ID: ${assetId}, ATP: ${asset.availableToPromiseTotal}] - Locked for reservation"/>
```

### 4. **Operational Logs**

```xml
<log message="Order [ID: ${orderId}, Product: ${productId}, Unit Amount: ${unitAmount}] - Calculated unit amount"/>
```

```xml
<log message="Shipment [ID: ${shipmentId}] - Updated status to SHIPPED"/>
```

```xml
<log message="Inventory [Facility: ${facilityId}, Product: ${productId}, QOH: ${quantityOnHandTotal}] - Adjusted quantity"/>
```

### 5. **Time Tracking Logs**

```xml
<log message="Process [Validated: ${validateCount} addresses, Elapsed: ${elapsedTime} minutes] - Address validation completed"/>
```

```xml
<log message="Shipment [ID: ${shipmentId}, Elapsed: ${elapsedTime} seconds] - Processing completed"/>
```

### 6. **Configuration and Setup Logs**

```xml
<log message="Configuration [ShippingGatewayConfig, Store: ${storeId}] - Loaded"/>
```

```xml
<log message="Facility [ID: ${facilityId}] - Initialized default locations"/>
```

### 7. **Inventory Adjustment Logs**

```xml
<log message="Inventory [Product: ${productId}, Adjustment: ${adjustmentQty}, New ATP: ${newAtp}] - ATP adjusted"/>
```

```xml
<log level="warn" message="Inventory [Product: ${productId}, Facility: ${facilityId}] - Negative ATP detected"/>
```

### 8. **User Action Logs**

```xml
<log message="User [ID: ${userLogin.userLoginId}, Order: ${orderId}] - Approved order"/>
```

```xml
<log message="User [ID: ${userLogin.userLoginId}, Shipment: ${shipmentId}] - Cancelled shipment"/>
```

### 9. **System Event Logs**

```xml
<log message="System [Job: ${jobId}] - Scheduled job execution completed successfully"/>
```

```xml
<log level="error" message="System [Job: ${jobId}] - Job execution failed with error ${errorMessage}"/>
```

### 10. **Exception Logs**

Always pair an exception with a pattern-compliant message. Many exceptions carry a null or
empty message, so logging only the exception produces useless lines like `|E| null`.

```xml
<!-- Bad: prints only "null" when the exception has no message -->
<log level="error" message="${exception.message}"/>

<!-- Good -->
<log level="error" message="Job [ID: ${jobId}] - Context deserialization failed: ${exception}"/>
```

```java
// Bad when used alone: the log line is just the exception message, often null
Debug.logError(e, MODULE);

// Good: the reader and the log tooling get entity, id, and what failed
Debug.logError(e, "Job [ID: " + jobId + "] - Context deserialization failed", MODULE);
```

---

## **Guidelines for Writing Log Messages**

1. **Consistent Format**:
    - Follow the structure:
      ```plaintext
      [Entity] [Context] - [Action/Outcome/Issue]
      ```

2. **Include Entity and Context**:
    - **Entity**: Clearly specify the entity (e.g., `Order`, `Shipment`, `Asset`, `Inventory`).
    - **Context**: Include dynamic data like IDs, statuses, or totals (e.g., `ID: ${orderId}`, `Facility: ${facilityId}`).

3. **Clarity and Brevity**:
    - Make messages concise but informative. Avoid ambiguity or excessive detail.

4. **Dynamic Data**:
    - Use placeholders for dynamic values to make messages contextual and insightful (e.g., `${orderId}`, `${shipmentId}`, `${elapsedTime}`).

5. **No Redundant Prefixes**:
    - Since Log4j already categorizes log levels (e.g., `error`, `warn`), do not add `[Error]` or `[Warning]` prefixes.

6. **Standard Log Levels**:
    - **`info`**: For regular operations.
    - **`warn`**: For potential issues or risks.
    - **`error`**: For critical failures or missing configurations.

7. **Track Time Where Relevant**:
    - Include elapsed time for processes or operations that need performance monitoring.

8. **Keep the Action Clause Constant**:
    - Put every dynamic value inside the `[Context]` block. The action text after the `-` stays identical across occurrences, so log tools can group and count messages reliably (e.g., Grafana/Loki pattern matching, "count by message").
    - One exception: a trailing error detail may be appended after the constant action, e.g. `- Could not connect: ${errorMessage}`.

9. **Never Log a Bare Exception**:
    - Always pair the exception with a pattern-compliant message naming the entity and its identifiers. Exceptions with null messages otherwise produce lines like `|E| null`, which cannot be analyzed at all.

---

