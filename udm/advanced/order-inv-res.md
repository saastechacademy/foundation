Reference 

https://confluence.hotwaxmedia.com/display/ETAILSNDBX/Warehouse+Order+Fulfillment+System



#### **Order Fulfillment:**

Order fulfillment can be defined as group of activities which company performs once the Order is placed by customer till the Order has been delivered. How well Company fulfills Order results in how well you satisfy and retain your customer. So Order fulfillment plays very crucial role in supply chain management and one of the important business process. 

 

###### **Created:**

Order is placed in Created Status . Order can be auto - approved.


###### **Approved: **


The business rules:

1. Address Validation check. There must be some address validation check using Third Party API . If address is not validated, Order should not be marked as Approved. 
2. Payment should be authorized. Payment is authorized when Order is created. But this should also happens when Order is Approved. It may happen that due to failure of address validation check Order is in  created status for many days. After that when Order is marked as Approved there must be Payment authorization again. 

There can be more business checks which can be done before order is marked as approved. But we have figured out two for now. We will add more timely .



#### **Completed:**

When all the items of Order are shipped, payment is received and order is invoiced, Order should be mark as Completed. 
 


#### **Order Reservation Process:**

Order reservation is all about holding up the inventory for an order so that inventory is not allocated to any other order. Currently this is done when Order is created in system. But some times it happens that Order is in Created for many days, so in that case, inventory is blocked for Order and other Order which may needs is not getting it. So in that case Order reservation should be done after Order Approval process. This will make sure that when Order is ready to be executed then and then only inventory is blocked/reserved for it. So it depends on nature of business when reservation should be done. So works needs to be done so that system is flexible enough so that we can make reservation work on order creation or on order approval easily. 

 


#### **Data State Changes :**

Before Reservation Process:

 


<table>
  <tr>
   <td colspan="3" ><strong>OrderHeader</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>orderTypeId</strong>
   </td>
   <td><strong>statusId</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>SALES_ORDER
   </td>
   <td>ORDER_APPROVED
   </td>
  </tr>
</table>



<table>
  <tr>
   <td colspan="4" ><strong>OrderItem</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>orderItemSeqId</strong>
   </td>
   <td><strong>productId</strong>
   </td>
   <td><strong>quantity</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>prod-01
   </td>
   <td>4
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00002
   </td>
   <td>prod-02
   </td>
   <td>12
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00003
   </td>
   <td>prod-03
   </td>
   <td>7
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00004
   </td>
   <td>prod-04
   </td>
   <td>1
   </td>
  </tr>
</table>



<table>
  <tr>
   <td colspan="5" ><strong>OrderItemShipGroup</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>shipGroupSeqId</strong>
   </td>
   <td><strong>shipmentMethodTypeId</strong>
   </td>
   <td><strong>carrierPartyId</strong>
   </td>
   <td><strong>carrierRoleTypeId</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>PROIRITY
   </td>
   <td>USPS
   </td>
   <td>CARRIER
   </td>
  </tr>
</table>


 

After reservation process:

 


<table>
  <tr>
   <td colspan="3" ><strong>OrderHeader</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>orderTypeId</strong>
   </td>
   <td><strong>statusId</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>SALES_ORDER
   </td>
   <td>ORDER_APPROVED
   </td>
  </tr>
</table>



<table>
  <tr>
   <td colspan="4" ><strong>OrderItem</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>orderItemSeqId</strong>
   </td>
   <td><strong>productId</strong>
   </td>
   <td><strong>quantity</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>prod-01
   </td>
   <td>4
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00002
   </td>
   <td>prod-02
   </td>
   <td>12
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00003
   </td>
   <td>prod-03
   </td>
   <td>7
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00004
   </td>
   <td>prod-04
   </td>
   <td>1
   </td>
  </tr>
</table>



<table>
  <tr>
   <td colspan="5" ><strong>OrderItemShipGroup</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>shipGroupSeqId</strong>
   </td>
   <td><strong>shipmentMethodTypeId</strong>
   </td>
   <td><strong>carrierPartyId</strong>
   </td>
   <td><strong>carrierRoleTypeId</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>PROIRITY
   </td>
   <td>USPS
   </td>
   <td>CARRIER
   </td>
  </tr>
</table>



<table>
  <tr>
   <td colspan="5" ><strong>OrderItemShipGrpInvRes</strong>
   </td>
  </tr>
  <tr>
   <td><strong>orderId</strong>
   </td>
   <td><strong>shipGroupSeqId</strong>
   </td>
   <td><strong>orderItemSeqId</strong>
   </td>
   <td><strong>inventoryItemId</strong>
   </td>
   <td><strong>quantity</strong>
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>00001
   </td>
   <td>2001
   </td>
   <td>4
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>00002
   </td>
   <td>2004
   </td>
   <td>12
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>00003
   </td>
   <td>2101
   </td>
   <td>7
   </td>
  </tr>
  <tr>
   <td>10000
   </td>
   <td>00001
   </td>
   <td>00004
   </td>
   <td>2318
   </td>
   <td>1
   </td>
  </tr>
</table>

