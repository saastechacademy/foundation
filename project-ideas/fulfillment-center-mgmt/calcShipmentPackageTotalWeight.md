## calcShipmentPackageTotalWeight

# Note: We will do this computation in getShippingRates service. I think we may have use of this service.


**Purpose:**

ShipmentPackageContent has list of ShipmentItems and Qty of that ShipmentItem. To compute the weight of ShipmentPackage, write a dynamic view that gets me ShipmentPackage weight.
The primary goal of this function is to determine the weight of a single package within a shipment. 

Prepare dynamic view entity

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