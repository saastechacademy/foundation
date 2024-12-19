# Recommendations for `<return>` Messages

---

## **General Pattern for Return Messages**

### **Pattern Template**

```plaintext
[Entity] [Context] - [Issue/Action]
```

- **Entity**: The primary entity involved (e.g., `Order`, `Shipment`, `Asset`, `ReturnItem`).
- **Context**: Dynamic data providing specific identifiers (e.g., IDs, statuses).
- **Issue/Action**: Clear description of what went wrong or what action was taken.

---

## **Examples of Refactored Return Messages**

### 1. **Data Validation Errors**

```xml
<return error="true" message="ReturnItem [ID: ${returnId}:${returnItemSeqId}] - Not found"/>
```

---

### 2. **Status Transition Errors**

```xml
<return error="true" message="Order [ID: ${orderId}] - Cannot be returned in status ${orderPart.statusId}"/>
```

---

### 3. **Permission Errors**

```xml
<return error="true" message="Order [ID: ${orderId}] - Approve permission required"/>
```

---

### 4. **Operational Failures**

```xml
<return error="true" message="Inventory [Order ID: ${orderId}] - Not enough inventory available to place order"/>
```

---

### 5. **General Warnings**

```xml
<return type="warning" message="Payment [Total: ${paymentTotal}] - Less than shipment invoice total ${invoiceTotal}, not generating labels"/>
```

---

## **Guidelines for Writing Return Messages**

1. **Consistent Format**:
   - Follow the structure:
     ```plaintext
     [Entity] [Context] - [Issue/Action]
     ```

2. **Include Entity and Context**:
   - **Entity**: Clearly specify the entity (e.g., `Order`, `ReturnItem`, `Shipment`).
   - **Context**: Include relevant dynamic data like IDs and statuses (e.g., `ID: ${orderId}`, `Status: ${statusId}`).

3. **Avoid Redundancy**:
   - Since Log4j already categorizes log levels (e.g., `error`, `warn`).

4. **Dynamic Data**:
   - Use placeholders to provide dynamic context for easy identification (e.g., `${orderId}`, `${shipmentId}`).

---
