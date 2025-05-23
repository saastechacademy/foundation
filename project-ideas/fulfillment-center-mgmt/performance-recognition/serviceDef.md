## **4. System Processes**

The system relies on automated processes and potentially manual intervention. These processes are typically executed by scheduled jobs invoking specific services.

### **4.1. Scheduled Jobs**

Automated jobs will run on predefined schedules to trigger various system processes.

* **Daily Fulfillment Performance Review Generation Job:** This job runs once per day, typically scheduled after the last store closes for the day. It is responsible for invoking the "Daily Picker Performance Review Service" to compute and create PerformanceReview records for employees in the "PICKER" role.  
* **Recognition Issuance Jobs:** These jobs run on their own schedules (e.g., daily, weekly, end-of-period) and are responsible for analyzing existing PerformanceReview records and other criteria to issue PerformanceRecognition records. Multiple such jobs may exist, each potentially targeting different RecognitionTypes or evaluation cadences.

### **4.2. Daily Picker Performance Review Service**

This service is invoked by the "Daily Picker Performance Review Generation Job" and contains the specific business logic to generate daily performance reviews for pickers.

* **Trigger:** Executed daily, after the last store has closed (ensuring all of the day's operational data is available).  
* **Scope:**  
  * Targets all employees who have the RoleTypeId = "PICKER" (or a similar configured identifier for the picker role).  
  * Considers the performance data for the just-concluded operational day (e.g., from midnight to last store close).  
* **Process:**  
  1. **Fetch Operational Data:** For each targeted "PICKER" employee, gather relevant operational data for the day from source systems (e.g., order management system for orders picked/rejected, warehouse management system for shipping times).  
  2. **Compute Performance Metrics:** Calculate all defined PerformanceReviewItemTypes (e.g., ORDERS_PICKED, AVG_TIME_TO_SHIP) based on the fetched data for each picker.  
  3. **Create PerformanceReview Record:** For each picker, create one new PerformanceReview record.  
     * EmployeeId: The picker's ID.  
     * ReviewId: A newly generated unique ID for this review.  
     * RoleTypeId: "PICKER".  
     * FromDate: Start of the reviewed day.  
     * ThruDate: End of the reviewed day.  
     * Comments: Optional, can be system-generated notes if needed.  
  4. **Create PerformanceReviewItem Records:** For each metric calculated in step 2, create a corresponding PerformanceReviewItem record linked to the PerformanceReview record created in step 3.

### **4.3. Services for Recognition Issuance**

These services are invoked by their respective Recognition Issuance Jobs and contain the business logic to:

1. **Analyze Performance Data:** Access existing PerformanceReview records.  
2. **Evaluate for Recognition:** Compare employee performance (based on their reviews) and potentially other criteria against the conditions defined for various RecognitionTypes. For example, a service might look for the "PICKER" with the highest ORDERS_PICKED from the daily reviews of the past week.  
3. **Issue Recognition:** If criteria for a RecognitionType are met, create PerformanceRecognition records, populating EarnedByPerformanceReviewId, EarnedByEmployeeId, and EarnedByRoleTypeId where applicable. FromPartyId would typically be 'SYSTEM' for automated recognitions.  
4. **Trigger Notifications:** Trigger notifications to the recognized employee using the specified CommunicationTemplateId.

### **4.4. Manual Recognition Issuance**

Recognitions can also be issued manually by authorized personnel (e.g., managers):

1. An authorized user would select an employee (ToPartyId) and a RecognitionTypeId.  
2. They would provide necessary details like FromDate, optionally ThruDate (if not auto-calculated by RecognitionType), and Comments.  
3. The FromPartyId would be the ID of the user issuing the recognition.  
4. In this case, EarnedByPerformanceReviewId, EarnedByEmployeeId, and EarnedByRoleTypeId would be left null.  
5. Notifications might still be triggered based on the RecognitionType.

### **4.5. Note on Extensibility**

When a new type of recognition is introduced to the system:

* A new RecognitionType record must be created.  
* If it's a system-generated recognition (issued by a Recognition Issuance Job):  
  * The corresponding service logic within the Recognition Issuance services will need to be updated or extended to evaluate criteria for this new RecognitionType. This might involve creating a new dedicated Recognition Issuance Job and Service if the evaluation logic is significantly different.  
* If a new PerformanceReviewItemType is needed for calculations:  
  * The PerformanceReviewItemType enumeration must be updated.  
  * The "Daily Picker Performance Review Service" (and any other relevant performance review generation services) must be updated to compute and store this new metric.  
* If it's primarily for manual issuance, ensuring the RecognitionType is available in the UI for manual award would be the main step.

## **5. Data Integrity and Relationships**

* A PerformanceReview (which is role-specific) can have multiple PerformanceReviewItem records, each detailing a specific metric for that role and review period.  
* A PerformanceRecognition *can* be linked to a specific PerformanceReview (and thus a specific role context) that justifies the award.  
* A PerformanceRecognition is always of a specific RecognitionType.

This flexible structure allows for both automated, performance-driven recognitions (which can now be role-specific) and discretionary manual awards, fostering a comprehensive and motivating environment for retail staff.