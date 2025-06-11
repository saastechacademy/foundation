# 🧬 Vue 3 `reactive()` API — Structured Reactive State

This document explains how to use the `reactive()` function in Vue 3’s Composition API to manage complex reactive objects and arrays.

---

## 🔍 What Is `reactive()`?

`reactive()` makes a plain JavaScript object reactive. Vue tracks changes to all nested properties and triggers updates to the DOM or computed values as needed.

```ts
import { reactive } from 'vue'

const user = reactive({
  name: 'Anil',
  age: 54
})
```

---

## 🧠 Java Developer Analogy

| Vue Concept        | Java Equivalent                       |
|--------------------|----------------------------------------|
| `reactive({})`     | POJO with observable fields (e.g. `@Bindable`) |
| `user.name = ...`  | `user.setName()` that notifies observers     |

---

## ✅ Template Usage

```vue
<template>
  <p>{{ user.name }}</p>
  <p>{{ user.age }}</p>
</template>
```

No `.value` is needed in templates when using `reactive()`.

---

## ⚠️ Important Considerations

### 1. ❌ Destructuring Breaks Reactivity

```ts
const { name } = user  // ❌ Not reactive
```

### ✅ Fix with `toRefs()`

```ts
import { toRefs } from 'vue'

const user = reactive({ name: 'Anil', age: 54 })
const { name, age } = toRefs(user)  // ✅ now both are reactive refs
```

---

### 2. Use `ref()` for Primitives

```ts
const count = ref(0)   // ✅
const broken = reactive(0)  // ❌ invalid
```

---

### 3. Arrays Are Reactive

```ts
const items = reactive(['pen', 'marker'])
items.push('eraser')  // Reactivity works
```

---

## 🔁 Comparison: `reactive()` vs `ref()`

| Feature                | `ref()`                      | `reactive()`                         |
|------------------------|-------------------------------|--------------------------------------|
| Use case               | Primitives                   | Objects, Arrays                      |
| Value Access (code)    | `.value`                     | Direct (`user.name`)                 |
| Template Usage         | Auto-unwrapped               | Auto-unwrapped                       |
| Destructuring support  | Use `.value` or `toRefs()`   | Use `toRefs()`                       |

---

## 🧪 Real Example

```ts
const product = reactive({
  id: 101,
  name: 'T-Shirt',
  variants: [
    { color: 'blue', size: 'M' },
    { color: 'black', size: 'L' }
  ]
})
```

You can:
- Use this in template
- Watch deep properties with `deep: true`
- Bind fields to forms

---

