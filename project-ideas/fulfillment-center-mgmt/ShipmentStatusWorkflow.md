
### **Shipment Status Workflow**

1.  **Initial Status:**  A shipment starts in the `SHIPMENT_INPUT` status (Created).

2.  **Possible Transitions:**
    *   From `SHIPMENT_INPUT`:
        *   It can be Scheduled (`SHIPMENT_SCHEDULED`), Picked (`SHIPMENT_PICKED`), or Packed (`SHIPMENT_PACKED`).
        *   It can also be Canceled (`SHIPMENT_CANCELLED`) or Approved (`SHIPMENT_APPROVED`).

    *   From `SHIPMENT_APPROVED`:
        *   It can be Packed (`SHIPMENT_PACKED`), Shipped (`SHIPMENT_SHIPPED`), or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_SCHEDULED`:
        *   It can be Picked (`SHIPMENT_PICKED`), Packed (`SHIPMENT_PACKED`), or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_PICKED`:
        *   It can be Packed (`SHIPMENT_PACKED`) or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_PACKED`:
        *   It can be Shipped (`SHIPMENT_SHIPPED`), Cancelled (`SHIPMENT_CANCELLED`), or moved back to Input (`SHIPMENT_INPUT`) under certain conditions.

    *   From `SHIPMENT_SHIPPED`:
        *   It can be Delivered (`SHIPMENT_DELIVERED`).

**Conditions and Rules**

*   Some transitions have conditional expressions:
    *   `directStatusChange == false`: This suggests that some transitions can only happen indirectly (through other intermediate statuses) and cannot be directly changed by the user.

**References**
*   Shipment and related entities can be found in Data model resource book vol -1 , Chapter - 5. 


