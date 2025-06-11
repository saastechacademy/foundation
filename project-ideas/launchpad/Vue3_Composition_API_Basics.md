# 📘 Vue 3 Composition API Basics — For Java/Moqui Developers

This document summarizes the key concepts, analogies, and behavior of the Vue 3 Composition API — especially for developers transitioning from enterprise Java frameworks like Moqui.

---

## 🚀 What is the Composition API?
Vue 3's Composition API is a modern approach to defining logic in components using **functions**, **reactive state**, and **lifecycle hooks** — replacing the older Options API.

It gives you more flexibility, better code organization, and improved TypeScript support.

---

## 🔹 Key Concepts and Their Java Equivalents

| Vue Concept        | Java Analogy                      | Purpose                                           |
|--------------------|-----------------------------------|---------------------------------------------------|
| `setup()`          | `runService()`, `init()`          | Component's main entry point                      |
| `ref()`            | `AtomicReference`, Box<T>         | Reactive reference to a single value              |
| `.value`           | `ref.get()` / `ref.set()`         | Access or modify the actual value inside `ref()`  |
| `reactive()`       | Mutable JavaBeans                 | Reactive object with tracked properties           |
| `computed()`       | Virtual fields                    | Derived/calculated values                         |
| `watch()`          | Event listener                    | Runs logic when a reactive source changes         |

---

## 🧪 `ref()` in Detail

### What it does:
```ts
const count = ref(0)
```
- `count` is **not** the number `0`
- It's an **object** that looks like: `{ value: 0 }`
- You mutate it like: `count.value++`

### Why Vue wraps primitives
JavaScript primitives are immutable, so Vue needs a wrapper to make them reactive.

```ts
let x = 0
x++       // Vue cannot track this

const rx = ref(0)
rx.value++ // ✅ Vue tracks and updates the DOM
```

### In Templates
```vue
<template>
  <p>{{ count }}</p> <!-- Vue automatically uses count.value -->
</template>
```

---

## 🔐 About `const`

```ts
const count = ref(0)
```

Means:
- `count` (the variable name) **cannot be reassigned**
- But the `.value` inside it **can** change

```ts
count = somethingElse  // ❌ Error
count.value = 5         // ✅ Works
```

This pattern is perfect for UI state: stable reference, mutable value.

---

## ✅ Summary

| Concept             | Rule/Usage                                      |
|---------------------|--------------------------------------------------|
| `ref()`             | Use for single reactive values                   |
| `count.value`       | Access/mutate the value                         |
| `const` + `ref()`   | Common pattern: stable variable, reactive state |
| Auto unwrap in DOM  | No `.value` needed inside `<template>`          |

