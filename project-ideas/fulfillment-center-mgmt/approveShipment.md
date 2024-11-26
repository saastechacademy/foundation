## approveShipment 


Step 1: For each Package in the Shipment, Compute the shipment package weight and update it on the ShipmentPackage.

Step 2: createShipmentStatus. First create "SHIPMENT_APPROVED" record in ShipmentStatus table 

Step 3: update the StatusId on Shipment table to "SHIPMENT_APPROVED"


Implementation notes:

ShipmentPackageContent has list of ShipmentItems and Qty of that ShipmentItem. To compute the weight of ShipmentPackage, write a dynamic view that gets me ShipmentPackage weight.

**View Entity Definition**

```sql
SELECT
    spc.shipment_id,
    spc.shipment_package_seq_id,
    spc.quantity,
    SUM((p.shipping_weight * spc.quantity)) AS total_weight,
    (SUM((p.shipping_weight * spc.quantity)))*uc.conversion_factor AS total_weight_lbs
FROM
    shipment_package_content spc
JOIN
    shipment_item si ON spc.shipment_id = si.shipment_id AND spc.shipment_item_seq_id = si.shipment_item_seq_id
JOIN
    product p ON si.product_id = p.product_id
JOIN
    uom_conversion uc ON p.weight_uom_id = uc.uom_id AND uc.uom_id_to = 'WT_lb'
WHERE
    si.shipment_id = 10082
GROUP BY
    si.shipment_id and spc.shipment_package_seq_id;

```

Note: 
We may end up writing services for each status transition 