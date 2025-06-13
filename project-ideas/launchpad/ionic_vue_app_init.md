
# Ionic + Vue App Initialization Summary

This document summarizes the initialization process of an Ionic + Vue application scaffolded using the Ionic CLI.

---

## 🛠 Steps to Scaffold the App

```bash
npm install -g @ionic/cli
ionic start web-frontend blank --type=vue
```

---

## 📂 Key Files and Their Roles

### 1. `main.ts`
Acts as the **entry point** (like `main()` in Java).
```ts
const app = createApp(App)
  .use(IonicVue)
  .use(router);

router.isReady().then(() => {
  app.mount('#app');
});
```
- Sets up the Vue application.
- Registers IonicVue and Vue Router.
- Waits for the router to be ready before mounting.

### 2. `index.html`
- Found at the **project root**, not in the `public/` folder (modern Vite convention).
- Contains the placeholder element `<div id="app"></div>`, where the Vue app mounts.

---

## 🚀 Initialization Flow

1. **HTML**: Vite serves `index.html`, which includes a `<div id="app">`.
2. **TS Entry Point**: `main.ts` is executed.
3. **Vue Setup**: Vue instance is created, IonicVue and router are injected.
4. **Router Ready**: Waits for router to resolve initial route.
5. **Mount App**: App is mounted into `#app` element.

---