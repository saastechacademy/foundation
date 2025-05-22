# ShopifyAppBridge

---

## ✅ Project Goal

Build a **Progressive Web App (PWA)** that runs as an **embedded app inside Shopify POS**, enabling authenticated access to backend APIs hosted on the HotWax OMS (built on Moqui).

---

## 🔐 Why This Authentication Flow?

### 1. **Why Session Tokens (JWTs)?**

**Because:**
Shopify POS does **not support OAuth redirects** or cookie-based sessions inside its webview environment. Instead, it provides a secure, short-lived **JWT session token** via **App Bridge**.

> *This is the only supported method for frontend→backend authentication in embedded Shopify apps.*

---

### 2. **Why HS256 and Shared Secret?**

**Because:**
Shopify signs the session token using `HS256` (a symmetric algorithm), where:

* Shopify holds the **private signing key**
* Your app (backend) holds the **shared secret** for verification

> *No need to fetch public keys. Verification happens **locally and immediately** using a known app secret.*

---

### 3. **Why We Validate on Every Request**

**Because:**
Shopify session tokens are **short-lived (\~1 minute)**. They are not meant to be cached or persisted.

> *A fresh token must be fetched from the frontend and validated for every request — enabling stateless, scalable, and secure access.*

---

### 4. **Why JWT Signature and Expiry are Sufficient (for Now)**

We chose to **verify only what Shopify guarantees and requires**:

* ✅ Signature (authenticity)
* ✅ `exp` (not expired)
* ✅ Claims `sub` (user) and `dest` (shop domain)

Optional claims like `aud`, `nbf`, and `iss` are **left out deliberately** for clarity and flexibility.

> *We’re not validating anything Shopify doesn’t recommend or enforce. Security is scoped to what the platform guarantees.*

---

### 5. **Why Not Use Access Token or OAuth Here?**

* Access tokens from Shopify’s OAuth flow are used to call the **Admin API** from the **backend**.
* Session tokens are used to **authenticate frontend → backend** requests made from the embedded app inside Shopify POS.

> *We’re correctly separating trust boundaries and token responsibilities.*

---

### 6. **The userLoginId in jwt.getSubject() exists in OMS**

* The authenticated user is then set in execution context for managing API call authorization.

---
## 🔒 Security Properties Achieved

| Security Goal                    | How It’s Achieved                               |
| -------------------------------- | ----------------------------------------------- |
| **Authentication of frontend**   | Shopify-signed JWT with HS256                   |
| **Tamper-proof tokens**          | Signature is verified using shared secret       |
| **Stateless backend**            | No session management — token is self-contained |
| **Request scoping by shop/user** | Extracted `dest` and `sub` claims               |
| **Replay prevention**            | Short token TTL (\~1 minute)                    |

---

### 7. Filter or Extend JWT Manager to support HS256

* The API call can be authenticated in few ways. 
  * Add servlet Filter, validate the JWT token and set the userLogin.
  * Alternatively  the co.hotwax.auth.JWTManager.validateToken method should check the "alg" attribute in header and use appropriate algorithm to validate the token.
    * If we go this route, the process to set userlogin object in execution context will be smooth, and we should be able to developing shopify-app-bridge component. 
