
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



```
<StatusType description="Shipment" hasTable="N"  statusTypeId="SHIPMENT_STATUS"/>
        <!-- Shipment status -->
    <StatusItem description="Created" sequenceId="01" statusCode="INPUT" statusId="SHIPMENT_INPUT" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Approved" sequenceId="08" statusCode="APPROVED" statusId="SHIPMENT_APPROVED" statusTypeId="SHIPMENT_STATUS"/>

    <!-- Shipment status -->
    <StatusItem description="Scheduled" sequenceId="02" statusCode="SCHEDULED" statusId="SHIPMENT_SCHEDULED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Picked" sequenceId="03" statusCode="PICKED" statusId="SHIPMENT_PICKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Packed" sequenceId="04" statusCode="PACKED" statusId="SHIPMENT_PACKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Shipped" sequenceId="05" statusCode="SHIPPED" statusId="SHIPMENT_SHIPPED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Delivered" sequenceId="06" statusCode="DELIVERED" statusId="SHIPMENT_DELIVERED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Cancelled" sequenceId="99" statusCode="CANCELLED" statusId="SHIPMENT_CANCELLED" statusTypeId="SHIPMENT_STATUS"/>

    <StatusValidChange statusId="SHIPMENT_APPROVED" statusIdTo="SHIPMENT_PACKED" transitionName="Pack"/>
    <StatusValidChange statusId="SHIPMENT_APPROVED" statusIdTo="SHIPMENT_INPUT" transitionName="Create" conditionExpression="directStatusChange == false"/>
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_CANCELLED" transitionName="Cancel"/>
    <!-- Shipment SHIPMENT_STATUS status valid change data -->
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_SCHEDULED' transitionName='Schedule' sequenceNum='01' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='04' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='03' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="05" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_INPUT' transitionName='input' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="04" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SHIPPED' statusIdTo='SHIPMENT_DELIVERED' transitionName='Deliver' sequenceNum='01' />
```


**References**
*   Shipment and related entities can be found in Data model resource book vol -1 , Chapter - 5. 


