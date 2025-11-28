## Order header graphQl  
This GraphQL query fetches the basic order details from Shopify. It retrieves only the top-level fields of the order without expanding or including any related connection data such as line items, fulfillments, transactions, refunds, or shipping lines.  
```gql
query {
  orders(first: 50) {
    pageInfo {
      hasNextPage
      endCursor
      startCursor
    }
    edges {
      node {
        legacyResourceId
        id
        name
        customArttributes {
          key
          value
        }
        staffMember {
          Id
        }
        tags
        totalPriceSet {
          shopMoney {
            amount
            currencyCode
          }
        }
        sourceName
        statusPageUrl
        shippingAddress {
          name
          address1
          address2
          city
          country
          zip
          provinceCode
          countryCodeV2
          latitude
          longitude
          phone
        }
        billingAddress {
          firstName
          lastName
          phone
          address1
          address2
          longitude
          latitude
          city
          province
          country
          zip
          countryCode
        }
        phone
        email
        displayFulfillmentStatus
        retailLocation {
          id
          legacyResourceId
        }
        customer {
          legacyResourceId
          id
          firstName
          lastName
        }
        customAttributes {
          key
          value
        }
        note
        createdAt
        cancelledAt
        closedAt
        currencyCode
        presentmentCurrencyCode
      }
    }
  }
}
