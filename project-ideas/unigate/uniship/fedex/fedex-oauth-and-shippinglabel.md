# Using OAuth Access Tokens with the FedEx API (Moqui Example)

## Overview
When interacting with the FedEx API, you do not use your API key and secret directly for every request. Instead, you first obtain a temporary OAuth access token, which is then used to authenticate and authorize all subsequent API requests, such as creating shipping labels.

## Why Use an Access Token?
- **Security**: Your API key and secret are permanent credentials. By exchanging them for a short-lived token (valid for 60 minutes), you reduce the risk of credential leakage.
- **Best Practice**: OAuth 2.0 is the industry standard for secure API authentication.
- **Revocability**: Tokens can be revoked or allowed to expire, providing better control and auditability.

## How the Process Works

### 1. Obtain OAuth Token from FedEx
```java
import org.moqui.util.RestClient;
import org.moqui.context.ExecutionContext;

ExecutionContext ec = ...; // Obtain the ExecutionContext
ShippingGatewayAuthConfig smr = ...; // Obtain the ShippingGatewayAuthConfig
// Using ShippingGatewayAuthConfig for managing client_id and client_secret
String clientId = smr.remoteId;
String clientSecret = smr.sharedSecret;

// 1. Get OAuth token
RestClient restClient = ec.service.rest();
def oauthUriBuilder = restClient.uri()
    .protocol("https")
    .host("apis-sandbox.fedex.com")
    .path("/oauth/token")
    .parameter("client_id", clientId)
    .parameter("client_secret", clientSecret)
    .parameter("grant_type", "client_credentials");

String accessToken = oauthUriBuilder.build().call().jsonObject().access_token;
```

### Using ShippingGatewayAuthConfig for FedEx API Credentials

To manage the `client_id` and `client_secret` for each retailer's account with FedEx, we will utilize the `ShippingGatewayAuthConfig` entity. The following fields will be used:

- **ShippingGatewayAuthConfig.remoteId**: This field will store the `client_id` for the retailer's FedEx account.
- **ShippingGatewayAuthConfig.sharedSecret**: This field will store the `client_secret` associated with the retailer's FedEx account.

### 2. Use the Token to Create a Shipping Label
```java
// 2. Prepare shipping label request

def shippingLabelUriBuilder = restClient.uri()
    .protocol("https")
    .host("apis-sandbox.fedex.com")
    .path("/ship/v1/shipments");

// Populate requestBody with required fields per FedEx API spec...
Map<String, Object> requestBody = new HashMap<>();
// Add necessary parameters to requestBody...

// 3. Create shipping label
RestClient.RestResponse restResponse = shippingLabelUriBuilder.call(requestBody, 
    Map.of("Authorization", "Bearer " + accessToken));
Map<String, Object> responseMap = (Map<String, Object>) restResponse.jsonObject();

System.out.println(responseMap);
```

### 3. Example Usage
```java
public class FedExExample {
    public static void main(String[] args) throws Exception {
        ShippingGatewayAuthConfig smr = ...; // Obtain the SystemMessageRemote
        // Using SystemMessageRemote for managing client_id and client_secret
        String clientId = smr.remoteId;
        String clientSecret = smr.sharedSecret;

        // 1. Get OAuth token
        String accessToken = getAccessToken(clientId, clientSecret);

        // 2. Prepare shipping label request (simplified)
        Map<String, Object> requestBody = new HashMap<>();
        // Populate requestBody with required fields per FedEx API spec...

        // 3. Create shipping label
        Map<String, Object> labelResponse = createShippingLabel(accessToken, requestBody);
        System.out.println(labelResponse);
    }

    public static String getAccessToken(String clientId, String clientSecret) {
        // implementation of getAccessToken using Moqui's RestClient
    }

    public static Map<String, Object> createShippingLabel(String accessToken, Map<String, Object> requestBody) {
        // implementation of createShippingLabel using Moqui's RestClient
    }
}
```
Reference:

* https://developer.fedex.com/api/en-us/Api-recipes/us-domestic-e-commerce.html
* https://developer.fedex.com/api/en-us/catalog/rate/v1/docs.html
* https://developer.fedex.com/api/en-us/catalog/ship/v1/docs.html

