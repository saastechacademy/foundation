# Common Patterns in `<return>` Messages

1. **Data Validation Errors**
    - **Example**:
      ```xml
      <return error="true" message="Return item ${returnId}:${returnItemSeqId} in status ${returnItem.status?.description} cannot be cancelled"/>
      ```
    - **Pattern**:  
      `"Entity ${entityId}:${subEntityId} in status ${status} cannot perform ${operation}"`
    - **Use Case**: When a data entity is in an invalid state to perform a requested action.

2. **Entity Not Found Errors**
    - **Example**:
      ```xml
      <return error="true" message="Could not find Order Item ${orderId}:${orderItemSeqId}"/>
      ```
    - **Pattern**:  
      `"Could not find ${entityType} ${entityId}:${subEntityId}"`
    - **Use Case**: When a referenced entity cannot be located.

3. **Status Transition Errors**
    - **Example**:
      ```xml
      <return error="true" message="Items may be deleted only when item is in Created, Requested, and Cancelled statuses"/>
      ```
    - **Pattern**:  
      `"Action ${action} allowed only when ${entityType} is in ${allowedStatuses} statuses"`
    - **Use Case**: When an operation violates a valid status transition.

4. **Dynamic Context Inclusion**
    - **Example**:
      ```xml
      <return error="true" message="Inventory required but not all available, not placing order ${orderId}"/>
      ```
    - **Pattern**:  
      `"${reason}, not completing ${action} ${entityId}"`
    - **Use Case**: When an action fails due to a dynamic condition.

5. **Null or Missing Field Errors**
    - **Example**:
      ```xml
      <return error="true" message="Order ${baseOrderId} is not a recurring order (has no recur cron expression)"/>
      ```
    - **Pattern**:  
      `"${entityType} ${entityId} is missing required ${fieldName}"`
    - **Use Case**: When a required field or configuration is missing.

6. **General Operation Failures**
    - **Example**:
      ```xml
      <return error="true" message="Shipment ${shipmentId} is not in the Packed or Shipped status"/>
      ```
    - **Pattern**:  
      `"${entityType} ${entityId} is not in the ${requiredStatus} status"`

---

### **Recommended Patterns for Insightful Error Messages**

To maintain consistency and improve error monitoring, adopt the following patterns for `<return>` messages:

1. **Entity State Validation**
    - **Template**:  
      `"${Entity} ${entityId}:${subEntityId} cannot ${operation} in ${currentState} state"`

2. **Entity Not Found**
    - **Template**:  
      `"${EntityType} ${entityId} not found"`

3. **Action Failure with Context**
    - **Template**:  
      `"${Reason} preventing ${action} for ${entityType} ${entityId}"`

4. **Field or Parameter Validation**
    - **Template**:  
      `"Missing or invalid ${fieldName} for ${entityType} ${entityId}"`

5. **Dynamic Condition Error**
    - **Template**:  
      `"Condition not met: ${dynamicCondition}, cannot ${action} ${entityId}"`

---

### **Guidelines for Writing Error Messages**

1. **Be Specific**: Clearly identify the entity type, IDs, and current state.
2. **Include Context**: Provide contextual information such as status, required fields, or reason for failure.
3. **Use Consistent Patterns**: Standardize error messages for common scenarios (e.g., validation errors, entity not found).
4. **Avoid Ambiguity**: Ensure messages are precise and unambiguous.
5. **Dynamic Data**: Leverage placeholders to include dynamic data like IDs, statuses, or field names.

By following these patterns, error messages become easier to read, troubleshoot, and monitor in production environments.