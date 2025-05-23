## **3. Entity Definitions**

The system utilizes several key entities to manage performance data and recognitions. These are detailed below.

### **3.1. Performance Tracking Entities**

These entities are responsible for capturing and storing data related to employee performance.

#### **3.1.1. Performance Review**

The PerformanceReview entity records an employee's overall performance assessment for a defined period and for a specific role. It can also serve as an aggregation of more granular performance reviews.

| Attribute | Data Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| EmployeeId | String | PK | Unique identifier for the employee. |
| ReviewId | String | PK | Unique identifier for this specific performance review instance. |
| RoleTypeId | String | PK, FK | Identifier for the role the employee was performing during this review period (e.g., 'CSR', 'PICKER'). |
| FromDate | Date/Time | Not Null | The start date/time of the period this review covers. |
| ThruDate | Date/Time | Not Null | The end date/time of the period this review covers. |
| Comments | String | Optional | Any additional comments or notes regarding this specific performance review. |

*Primary Key (PK): (EmployeeId, ReviewId, RoleTypeId)* *Foreign Key (FK): (RoleTypeId) would typically reference a RoleType entity or enumeration (definition for RoleType entity not included in this document but assumed to exist).*

#### **3.1.2. Performance Review Item**

The PerformanceReviewItem entity stores specific metrics or aspects of an employee's performance within a given PerformanceReview (for a specific role).

| Attribute | Data Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| EmployeeId | String | PK, FK | Foreign key referencing PerformanceReview.EmployeeId. |
| ReviewId | String | PK, FK | Foreign key referencing PerformanceReview.ReviewId. |
| RoleTypeId | String | PK, FK | Foreign key referencing PerformanceReview.RoleTypeId. |
| ReviewItemTypeId | String | PK | Identifier for the type of performance metric being recorded (see 3.1.3). |
| PerformanceValue | Numeric | Not Null | The actual measured value of the performance metric. |
| UnitOfMeasure | String | Not Null | The unit of measure for the PerformanceValue (e.g., "orders", "minutes"). |

*Primary Key (PK): (EmployeeId, ReviewId, RoleTypeId, ReviewItemTypeId)* *Foreign Key (FK): (EmployeeId, ReviewId, RoleTypeId) references PerformanceReview(EmployeeId, ReviewId, RoleTypeId)*

#### **3.1.3. Performance Review Item Types**

PerformanceReviewItemType defines the different kinds of metrics that can be tracked. These are typically stored in a shared Enumeration Table or a dedicated lookup table. Initial seed values include:

* ORDERS_PICKED: Number of orders picked.  
* ORDERS_REJECTED: Number of orders rejected.  
* MAX_TIME_TO_SHIP: Maximum time taken to ship an order.  
* AVG_TIME_TO_SHIP: Average time taken to ship orders.  
* MIN_TIME_TO_SHIP: Minimum time taken to ship an order.
 
Below is an example of how these types might be represented as XML data for an enumeration entity:  
```
<entity-engine-xml>  
    <Enumeration enumId="ORDERS_PICKED" enumTypeId="PERF_REVIEW_ITEM" description="Number of orders picked" sequenceNum="1"/>  
    <Enumeration enumId="ORDERS_REJECTED" enumTypeId="PERF_REVIEW_ITEM" description="Number of orders rejected" sequenceNum="2"/>  
    <Enumeration enumId="MAX_TIME_TO_SHIP" enumTypeId="PERF_REVIEW_ITEM" description="Maximum time taken to ship an order" sequenceNum="3"/>  
    <Enumeration enumId="AVG_TIME_TO_SHIP" enumTypeId="PERF_REVIEW_ITEM" description="Average time taken to ship orders" sequenceNum="4"/>  
    <Enumeration enumId="MIN_TIME_TO_SHIP" enumTypeId="PERF_REVIEW_ITEM" description="Minimum time taken to ship an order" sequenceNum="5"/>

    <EnumerationType enumTypeId="PERF_REVIEW_ITEM" description="Performance Review Item Types" hasTable="N" parentTypeId=""/>  
</entity-engine-xml>
```

### **3.2. Recognition Entities**

These entities are used to define and issue recognitions based on employee performance or manual input.

#### **3.2.1. Performance Recognition**

The PerformanceRecognition entity records an instance of a recognition being awarded to an employee. This can be based on a performance review (for a specific role) or issued directly.

| Attribute | Data Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| RecognitionId | String | PK | Unique identifier for this specific recognition instance. |
| FromPartyId | String | Not Null | Identifier of the party/system issuing the recognition (e.g., 'SYSTEM' for automated, or a manager's ID for manual). |
| ToPartyId | String | Not Null | Identifier of the employee (party) receiving the recognition. Likely EmployeeId. |
| ToFacilityId | String | Optional | Identifier of the facility associated with the recognition, if applicable. |
| FromDate | Date/Time | Not Null | The start date/time for which this recognition is valid or was earned. |
| ThruDate | Date/Time | Optional | The end date/time for which this recognition is valid (can be auto-populated based on RecognitionType). |
| RecognitionTypeId | String | Not Null, FK | Foreign key referencing RecognitionType.RecognitionTypeId. |
| EarnedByPerformanceReviewId | String | Optional, FK | Foreign key referencing PerformanceReview.ReviewId. Links recognition to a specific performance review, if applicable. |
| EarnedByEmployeeId | String | Optional, FK | Foreign key referencing PerformanceReview.EmployeeId. Used when EarnedByPerformanceReviewId is present. |
| EarnedByRoleTypeId | String | Optional, FK | Foreign key referencing PerformanceReview.RoleTypeId. Used when EarnedByPerformanceReviewId is present. |
| Comments | String | Optional | Comments for the recognition, especially useful for manually awarded ones. |

*Primary Key (PK): (RecognitionId)* *Foreign Key (FK): (RecognitionTypeId) references RecognitionType(RecognitionTypeId)* *Foreign Key (FK): (EarnedByEmployeeId, EarnedByPerformanceReviewId, EarnedByRoleTypeId) references PerformanceReview(EmployeeId, ReviewId, RoleTypeId) where EarnedByPerformanceReviewId is not null.*  

**Note on EarnedByEmployeeId, EarnedByPerformanceReviewId, and EarnedByRoleTypeId:**

* These fields are optional to support recognitions awarded manually without a direct link to a system-generated performance review.  
* When a recognition *is* linked to a performance review, EarnedByEmployeeId, EarnedByPerformanceReviewId, and EarnedByRoleTypeId should all be populated.  
* For manually awarded recognitions, ToPartyId will hold the recipient employee's ID, and EarnedByPerformanceReviewId, EarnedByEmployeeId, and EarnedByRoleTypeId would be null. FromPartyId would typically be the ID of the manager awarding it.

#### **3.2.2. Recognition Type**

The RecognitionType entity defines the different types of recognitions that can be awarded, along with their associated properties.

| Attribute | Data Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| RecognitionTypeId | String | PK | Unique identifier for the recognition type (e.g., "MOST_ORDERS_SHIPPED_WEEKLY", "EMPLOYEE_OF_THE_MONTH"). |
| RecognitionTypeName | String | Not Null | A user-friendly name for the recognition (e.g., "Top Shipper of the Week", "Employee of the Month"). |
| RecognitionTypeDesc | String | Optional | A more detailed description of what the recognition signifies. |
| ContentId | String | Optional | Identifier for associated visual content, such as a badge image URL or asset key. |
| CommunicationTemplateId | String | Optional | Identifier for a communication template (e.g., an email FTL template ID) to notify the recipient. |
| AutoExpirationDays | Integer | Optional | Number of days after issuance that a recognition of this type automatically expires (used to calculate ThruDate in PerformanceRecognition). |

*Primary Key (PK): (RecognitionTypeId)*
