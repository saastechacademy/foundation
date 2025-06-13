
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

## 🚀 App Bootstrapping Flow

1. **`main.ts` executes**

    * Mounts the root Vue application using `createApp(App)`
    * Installs plugins like `IonicVue` and `router`
    * Waits for `router.isReady()` before mounting app to `#app`

```ts
const app = createApp(App)
  .use(IonicVue)
  .use(router)

router.isReady().then(() => {
  app.mount('#app')
})
```

2. **`App.vue` is mounted**

    * This acts as the root component for your app.
    * Lifecycle events in `App.vue` are triggered.

---

## 🔄 Vue Component Lifecycle (Composition API)

For components like `App.vue` or any pages (e.g., `Home.vue`, `Login.vue`), the most important lifecycle hooks are:

| Hook                | Description                                                                |
| ------------------- | -------------------------------------------------------------------------- |
| `setup()`           | Called before component is created. Used for declaring reactive variables. |
| `onBeforeMount()`   | Before the component is mounted to the DOM.                                |
| `onMounted()`       | After the component is mounted. Good place for API calls or setup logic.   |
| `onBeforeUpdate()`  | Before the DOM updates due to reactive changes.                            |
| `onUpdated()`       | After the DOM has been updated.                                            |
| `onBeforeUnmount()` | Before the component is destroyed.                                         |
| `onUnmounted()`     | After the component is destroyed.                                          |

> ✅ In PWA apps, most logic like checking login state, fetching user data, or routing happens in `onMounted()` of `App.vue` or the page-level components.

---

## 🧠 Ionic-Specific Lifecycle (Optional)

If you're building apps with navigation between pages using Ionic’s `ion-router-outlet`, also be aware of:

| Ionic Lifecycle Hook | Description                                                     |
| -------------------- | --------------------------------------------------------------- |
| `ionViewWillEnter`   | Fires when the view is about to become active.                  |
| `ionViewDidEnter`    | Fires when the view is fully active. Good for async data fetch. |
| `ionViewWillLeave`   | Fires when the view is about to leave.                          |
| `ionViewDidLeave`    | Fires when the view has fully left and is no longer active.     |

To use these, you must import from `@ionic/vue`:

```ts
import { onIonViewDidEnter } from '@ionic/vue'

onIonViewDidEnter(() => {
  console.log('Page is active')
})
```

---

## 🛠 Typical Initialization Pattern

In most PWA apps:

* `App.vue` checks for token in `onMounted`
* Routes the user to `Login.vue` if not authenticated
* Otherwise proceeds to home/dashboard

