
# Shopify POS Embedded App Development Setup

## ✅ Basic Dev Setup for Shopify POS Embedded App using Ionic + Vue

### 1. Install Pre-requisites
- ✅ Confirmed Homebrew, Node.js (`v24.1.0`), and npm (`11.3.0`) were installed.
- ✅ Installed `ngrok` for secure HTTPS tunneling (`ngrok version 3.22.1`).
- ✅ Installed Shopify CLI, later switched to installing only `@shopify/cli` via npm (not via Homebrew).

### 2. Scaffold Ionic + Vue App
```bash
ionic start web/frontend blank --type=vue
```
- This created a clean app in `web/frontend` with basic routing and layout using Vue.

### 3. Fix Broken Create Command
You initially tried:
```bash
npm create @ionic/vue@latest web/frontend
```
Which failed. The working command was:
```bash
ionic start web/frontend blank --type=vue
```

### 4. Install Global Ionic CLI (new package name)
```bash
npm uninstall -g ionic
npm install -g @ionic/cli
```

### 5. Install Shopify App Bridge Dependencies
```bash
npm install @shopify/app-bridge @shopify/app-bridge-utils axios
```

### 6. App Bridge Token Flow Plan
- On app init: use `getSessionToken(appBridge)`
- Call backend `validate#ShopifySessionToken`
- Store returned OMS token via `authStore.setToken()`
- Fetch user profile and save via `authStore.setCurrent()`

### 7. Shared Session with Sub-Apps
- Your plan involves using a single published app called `HCApps`.
- After authentication, show tiles for sub-apps like Inventory Count.
- All apps reuse `authStore` and `apiConfig`.
