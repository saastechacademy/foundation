## Sample output for GraphQl queries
This has been tested on gorjana sandbox
### Order header graphQl query cost
50 order per Shopif call
```graphql
"extensions": {
        "cost": {
            "requestedQueryCost": 79,
            "actualQueryCost": 79,
            "throttleStatus": {
                "maximumAvailable": 20000.0,
                "currentlyAvailable": 19921,
                "restoreRate": 1000.0
            }
        }
    }

```
### Order item graphQl query cost 
10 line items per order
```graphQl
"extensions": {
        "cost": {
            "requestedQueryCost": 27,
            "actualQueryCost": 14,
            "throttleStatus": {
                "maximumAvailable": 20000.0,
                "currentlyAvailable": 19986,
                "restoreRate": 1000.0
            }
        }
    }
```
### Order shipping lines query cost
5 line items per order
``` graphQl
 "extensions": {
        "cost": {
            "requestedQueryCost": 15,
            "actualQueryCost": 6,
            "throttleStatus": {
                "maximumAvailable": 20000.0,
                "currentlyAvailable": 19994,
                "restoreRate": 1000.0
            }
        }
```        
    
