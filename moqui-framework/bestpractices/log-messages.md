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
<log level="error" message="Inventory [Product ID: ${productId}] - Insufficient stock at Facility ${facilityId}"/>
```

### 3. **Asset Reservation Logs**

```xml
<log level="warn" message="AssetReservation [ID: ${assetReservationId}] - Invalid for OrderItem ${orderItem.orderId}:${orderItem.orderItemSeqId} at Facility ${asset.facilityId}"/>
```

```xml
<log level="warn" message="Asset [ID: ${assetId}] - Locked for reservation, remaining ATP: ${asset.availableToPromiseTotal}"/>
```

### 4. **Operational Logs**

```xml
<log message="Order [ID: ${orderId}] - Calculated unitAmount ${unitAmount} for Product ${productId}"/>
```

```xml
<log message="Shipment [ID: ${shipmentId}] - Updated status to SHIPPED"/>
```

```xml
<log message="Inventory [Facility: ${facilityId}] - Adjusted quantity for Product ${productId}, new QOH: ${quantityOnHandTotal}"/>
```

### 5. **Time Tracking Logs**

```xml
<log message="Process [Validated: ${validateCount} addresses] - Completed in ${elapsedTime} minutes"/>
```

```xml
<log message="Shipment [ID: ${shipmentId}] - Processing completed in ${elapsedTime} seconds"/>
```

### 6. **Configuration and Setup Logs**

```xml
<log message="Configuration [ShippingGatewayConfig] - Loaded for Store ${storeId}"/>
```

```xml
<log message="Facility [ID: ${facilityId}] - Initialized default locations"/>
```

### 7. **Inventory Adjustment Logs**

```xml
<log message="Inventory [Product: ${productId}] - ATP adjusted by ${adjustmentQty}, new ATP: ${newAtp}"/>
```

```xml
<log level="warn" message="Inventory [Product: ${productId}] - Negative ATP detected at Facility ${facilityId}"/>
```

### 8. **User Action Logs**

```xml
<log message="User [ID: ${userLogin.userLoginId}] - Approved Order ${orderId}"/>
```

```xml
<log message="User [ID: ${userLogin.userLoginId}] - Cancelled Shipment ${shipmentId}"/>
```

### 9. **System Event Logs**

```xml
<log message="System [Job: ${jobId}] - Scheduled job execution completed successfully"/>
```

```xml
<log level="error" message="System [Job: ${jobId}] - Job execution failed with error ${errorMessage}"/>
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

---

