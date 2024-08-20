# **Fulfillment Application Design Document**

### **Fulfillment Workflow**

1.  **Start Packing:** Packer enters picklist bin ID or scans item.
2.  **System Response:** System displays items in the picklist or in "INPUT" status. 
    *   Creates a new shipment if none exists.
    *   Shows progress of the current shipment.
3.  **Package Items:** Packer places items into packages, assigns items, and records weights.
4.  **Continue Packing?** System prompts packer.
    *   Yes: Packer continues packing.
    *   No: Proceed to next step.
5.  **Confirm Shipment:** Packer clicks "Confirm Shipment." System offers to edit shipping information.
6.  **Edit Shipping?**
    *   Yes: Packer edits shipping address or method.
    *   No: Proceed to next step.
7.  **Cancel Shipment?**
    *   Yes: Packer cancels the shipment.
    *   No: Proceed to next step.
8.  **Continue Shipping:** Packer gets tracking numbers and labels.
9. **System Updates:** System processes payment, marks shipment as "Shipped."
10. **Complete Packing:** Packer packs packages and places them in "PACKAGES" area.

### **Important Considerations:**

*   Integrate inventory deduction.
*   Add exception handling branches.
*   Implement notifications.
*   Detail integration with Order Management System.

