# Moqui services and REST API

Learning objective
* Define new REST APIs in Moqui
* Implement CRUD services in Moqui

### Prerequisite
Complete following tutorial in given order

[Services in Moqui] (https://youtu.be/6kFwPlPk92c)

Service XML Actions.
https://youtu.be/gAeYvAU9S2Y

Developing of REST APIs in Moqui.
https://youtu.be/IAt0HQVGMrQ

Overview of the Mantle Business Artifacts.
https://youtu.be/lV0RqRtrnbU

Fork and then clone following repository
https://github.com/hotwax/moqui-tutorial

Tasks 
1. Data load
Load data provided in moqui-tutorial component. 

2. REST API
Develop API to perform CRUD operations on order entities.
Note: You must use the existing OOTB Order entities available in the mantle component for this assignment. 

2a. Create Order
* Identify the entity to create the order with the data as per the below input schema.
* The input schema for the Create Order API should have the parameters as per the sample request body added below, with the following constraints.
  * Default currencyUomId parameter to “USD” if not passed in the request.
  * Default the statusId parameter to “OrderPlaced” if not passed in the request.
  * The orderName and placedDate parameters is required for creating the order.

* The successful API request should return the orderId for the new Order created.

```
{
    "orderName": "Test Order 1",
    "currencyUomId": "USD",
    "salesChannelEnumId": "ScWeb",
    "statusId": "OrderPlaced"
    "productStoreId": "OMS_DEFAULT_STORE",
    "placedDate": "2020-04-17",
    "approvedDate": "2020-04-19"
}
```
2b. Add Order Items
* Identify the entities involved in adding items to an order as per the below input schema.

* The input schema for the Add Order Items API should have the parameters as per the sample request body added below, with the following constraints.
  * The orderId, facilityId and customerPartyId parameters should be mandatory for adding the items to an existing order.
  * The shipmentMethodEnumId parameter should consider the default value of “ShMthGround” if not provided in the request.
  * The item_details parameter should be mandatory.
  * For each item inside the item_details, productId, quantity and unitAmount parameters should be mandatory.

* Use the existing customer with the partyId, “CustJqp”, available in the moqui-tutorial component, for creating the orders.
* The successful API request should output the orderId and orderPartSeqId.

```
{
    "orderId": "100000",
    "partName": "Test Order Part 1",
    "facilityId": "ZIRET_WH",
    "shipmentMethodEnumId": "ShMthGround",
    "customerPartyId": "CustJqp",
    "item_details": [{
        "productId": "DEMO_UNIT",
        "itemDescription": "Demo Product Unit One",
        "quantity": "1",
        "unitAmount": "16.99"
    },
    {
        "productId": "DEMO_1_1",
        "itemDescription": "Demo Product Unit Two",
        "quantity": "2",
        "unitAmount": "18.99"
    }]
}

```
2c. Get all Orders
* The API request should return the list of all orders.
* The output schema for the Get Orders API should have the parameters as per the sample response body added below. 

```
{
	"orders": [
{
	"orderId": "105001",				
	"orderName": "sample order 1",
	"currencyUom": "USD",
	"salesChannelEnumId": "ScWeb",
	"statusId": "OrderPlaced",				
	"placedDate": "2020-04-17",			
"grandTotal": 54.97,
      	"customer_details": {
		"customerPartyId": "100601",
	"firstName": "Sam",	
"middleName": "",				
	"lastName": "Wilson"
	},
	"order_parts": [{
		"orderPartSeqId": "01",	
           "partName": "Test Order Part 1",	
"facilityId": "ZIRET_WH",
           "shipmentMethodEnumId": "ShMthGround",	
           "partStatusId": "OrderPlaced",
           "partTotal": 54.97,
		"item_details": [{
			"orderItemSeqId": "01",		
		"productId": "DEMO_UNIT",
		"itemDescription": "Demo Product One Unit",
		"quantity":  1,
		"unitAmount":  16.99
	}, {
           "orderItemSeqId": "02",
                      "productId": "DEMO_1_1",
                       "itemDescription": "Demo Product Unit Two",
                       "quantity": "2",
                       "unitAmount": "18.99"
    }]
	}]
}]
}

```

2d. Get an Order
The API request should return information about an order by giving its order id.
Note: This API should return the information for the order as per the output schema of get orders API. 

2e. Update Order
* The API request should be able to update the order name for a given order Id, as per the sample request body added below.
```
{
   "orderId": "100000",
   "orderName": "My first order."
}
```

* The output schema for the API should have the parameters as per the sample response body added below.

```
{
    "orderId": "100000",
    "orderName": "My first order.",
    "currencyUomId": "USD",
    "salesChannelEnumId": "ScWeb",
    "statusId": "OrderPlaced"
    "productStoreId": "OMS_DEFAULT_STORE",
    "placedDate": "2020-04-17",
    "approvedDate": "2020-04-19",
    "grandTotal": 54.97
}
```


Run APIs

* Check the working of all the developed REST APIs by executing the requests using Postman.
