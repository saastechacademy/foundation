## **1\. Hyper Real-Time Inventory Sync**

* **Limited Edition Drops**  
   We release limited-edition, limited-inventory items. During product launches, our OMS must update inventory in real time across all channels (online, partner stores, outlet stores) to avoid overselling.  
* **Immediate Stock Updates**  
   Orders, cancellations, and returns should reflect instantly in our inventory system so staff and customers always see accurate availability.

## **2\. Order Handling and Packaging**

* **Flyers for First-Time Customers**  
   All first-time customers should receive a flyer in their shipment. The system should flag these orders automatically.  
* **Special Packaging for High-Priced Items**  
   We have a specific list of SKUs that need special boxes. The OMS should prompt packers with clear instructions to use the correct packaging.

## **3\. Partner Store Brokering**

* **20% Order Allocation**  
   We want to send 20% of online orders to our partner stores for fulfillment. The OMS should track partner store inventory and allocate orders accordingly.  
* **Prioritize Outlet Store Inventory**  
   Our outlet stores carry older or excess stock. We want these items to be the first choice for standard online orders whenever possible, unless the item must be handled by a partner store.

## **4\. SKU Management and Bundling**

* **Earring Single/Pair Conversion**  
   Some earrings can be sold individually or as a pair. When a pair is sold (a virtual SKU), the OMS needs to convert that into 2 units of the single-SKU item, reducing single-item stock properly.  
* **Bundles with ERP-Managed Components**  
   Certain products are sold as bundles (one main SKU), but the individual components are tracked in our ERP. When allocating, please ensure that bundles aren’t split up. If an order is partially fulfilled from multiple locations, each bundle still needs to ship as a complete set from a single location.

## **5\. Order Splitting Logic**

* **Minimum Split Value**  
   If an order needs splitting, each split portion should have a retail value of at least $50. If the partial split falls below that threshold, the system should keep the entire order together in one fulfillment location or highlight it as an exception.