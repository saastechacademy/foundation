# Note: We did not implement ShopifySessionTokenAuthFilter. Instead decided to add code in JWTManager for authenticating Shopify sessionToken. 

***Keeping the document for fun purposes.*** 


# ShopifySessionTokenAuthFilter - Design Document

## 📌 Purpose

The `ShopifySessionTokenAuthFilter` secures Moqui API endpoints exposed to Shopify embedded apps (POS or Admin) by validating short-lived session tokens (JWTs) issued by Shopify. This filter ensures requests are authenticated using Shopify App Bridge tokens signed with your app’s shared secret.

---

## 🔒 Authentication Model

| Source           | Shopify Embedded App (App Bridge) |
|------------------|------------------------------------|
| Token Type       | JWT (session token)                |
| Signing Algorithm| HS256 (HMAC SHA-256)               |
| Verification Key | App’s shared secret                |
| Auth Method      | `Authorization: Bearer <token>`    |

---

## ⚙️ Environment Configuration

| Variable               | Description                              |
|------------------------|------------------------------------------|
| `SHOPIFY_APP_SECRET`   | Used to verify the JWT signature          |

---

## 🧠 Core Logic (Inside `doFilter()`)

```groovy
void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) {
    if (!(req instanceof HttpServletRequest) || !(resp instanceof HttpServletResponse)) {
        chain.doFilter(req, resp)
        return
    }

    HttpServletRequest request = (HttpServletRequest) req
    HttpServletResponse response = (HttpServletResponse) resp
    ServletContext servletContext = req.getServletContext()
    ExecutionContextFactoryImpl ecfi = (ExecutionContextFactoryImpl) servletContext.getAttribute("executionContextFactory")
    if (ecfi == null) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System initializing. Please retry shortly.")
        return
    }

    ExecutionContextImpl ec = ecfi.getEci()

    try {
        String authHeader = request.getHeader("Authorization")
        if (!authHeader?.startsWith("Bearer ")) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Missing or invalid Authorization header.")
            return
        }

        String token = authHeader.substring("Bearer ".length())
        Algorithm algorithm = Algorithm.HMAC256(shopifyAppSecret)
        JWTVerifier verifier = JWT.require(algorithm).build()
        DecodedJWT jwt = verifier.verify(token)

        String shopDomain = jwt.getClaim("dest").asString()
        String shopUserId = jwt.getSubject()

        // Optional future validations
        // nbf (not before) check
        // iss == dest check
        // aud == app API key check

        if (!shopDomain || !shopUserId) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid session token claims.")
            return
        }

        logger.info("Authenticated Shopify session for shop ${shopDomain}, user ${shopUserId}")

        chain.doFilter(req, resp)

    } catch (JWTVerificationException e) {
        logger.warn("Invalid or expired Shopify session token: ${e.message}")
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid Shopify session token.")
    } catch (Throwable t) {
        logger.error("Shopify session token authentication error", t)
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Authentication error: ${t.message}")
    } finally {
        ec.destroy()
    }
}
```

---

## 🟨 Optional Validations (Commented in Code)

- `nbf` → Not before check
- `iss == dest` → Domain match
- `aud == API key` → Token audience match

---

## ✅ Success Behavior

- Logs shop and user info
- Continues with `chain.doFilter()`

---

## ❌ Failure Conditions

| Condition                  | HTTP Status         | Message                                  |
|----------------------------|----------------------|-------------------------------------------|
| Missing/invalid token      | 401 Unauthorized     | Missing or invalid Authorization header   |
| Signature invalid/expired  | 401 Unauthorized     | Invalid Shopify session token             |
| Claims missing             | 401 Unauthorized     | Invalid session token claims              |
| System not initialized     | 500 Internal Server Error | System initializing                      |
| Unexpected error           | 500 Internal Server Error | Authentication error                    |

---

## 🧪 Testing Tips

- Use Shopify App Bridge’s `getSessionToken()` in frontend
- Decode token at https://jwt.io
- Use mocked tokens in Postman or curl with Authorization header

## References 
- https://shopify.dev/docs/apps/build/authentication-authorization/session-tokens/set-up-session-tokens