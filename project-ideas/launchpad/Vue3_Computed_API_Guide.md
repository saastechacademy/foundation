# 🧠 Vue 3 `computed()` API — A Guide for Java/Moqui Developers

This document explains how to use the `computed()` function in Vue 3’s Composition API to create reactive, derived state — ideal for developers coming from enterprise Java backgrounds.

---

## 💡 What is `computed()`?

`computed()` lets you define **reactive values derived from other reactive values**. These are read-only by default and are **cached** until their dependencies change.

Think of it as:
- A **getter** for a dynamic value
- A **virtual field** in Java
- A **formula field** in Excel

---

## 📦 Basic Usage

```ts
import { ref, computed } from 'vue'

const firstName = ref('Anil')
const lastName = ref('Patel')

const fullName = computed(() => {
  return `${firstName.value} ${lastName.value}`
})
```

- `fullName` automatically updates when `firstName` or `lastName` changes.
- In templates, Vue unwraps it automatically:

```vue
<p>{{ fullName }}</p>
```

---

## ✅ Benefits

| Feature                       | Value                                            |
|------------------------------|--------------------------------------------------|
| Tracks dependencies           | Vue detects and updates when source changes     |
| Caches results                | Only recomputes when required                   |
| Clean and declarative         | Keeps logic compact and maintainable            |

---

## ✍️ Writable Computed Properties

```ts
const firstName = ref('Anil')
const lastName = ref('Patel')

const fullName = computed({
  get: () => `${firstName.value} ${lastName.value}`,
  set: (val) => {
    const [first, last] = val.split(' ')
    firstName.value = first
    lastName.value = last
  }
})

fullName.value = 'John Doe'
```

---

## 🆚 `computed()` vs `watch()`

| Feature            | `computed()`                        | `watch()`                         |
|--------------------|--------------------------------------|-----------------------------------|
| Purpose            | Derived value                       | Side effects                      |
| Returns            | A reactive value                    | No return, just runs function     |
| When it runs       | When accessed + dependencies change | When dependencies change          |
| Use case           | Display logic, formulas             | API calls, logging, async tasks   |

---

## 🧪 Real Example

```ts
const price = ref(100)
const tax = ref(0.18)

const total = computed(() => price.value * (1 + tax.value))
```

In a template:

```vue
<p>Total with tax: {{ total }}</p>
```

---

## ⚠️ Gotchas

1. You cannot mutate a `computed()` value unless you define `set()`
2. Computed properties are **lazy**: they don’t update until accessed
3. Use `watch()` for side effects, not derived values

---
