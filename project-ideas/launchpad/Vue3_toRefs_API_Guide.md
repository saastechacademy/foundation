# 🔗 Vue 3 `toRefs()` — Preserve Reactivity When Destructuring

This document explains how and why to use `toRefs()` in Vue 3 when working with `reactive()` objects and destructuring.

---

## 🔍 What Is `toRefs()`?

`toRefs()` takes a **reactive object** and returns a new object where each property is a `ref` pointing to the original.

### Why Use It?

Destructuring a `reactive` object **breaks reactivity** unless you use `toRefs()`:

```ts
const state = reactive({ count: 0 })

const { count } = state      // ❌ Not reactive
const { count } = toRefs(state) // ✅ Reactive ref
```

---

## 🧪 Real Example

```ts
const form = reactive({
  name: 'Anil',
  age: 54
})

const { name, age } = toRefs(form)
```

- `name` and `age` are now `ref`s.
- They stay connected to `form`.

---

## ✅ Component Use Case

```vue
<script setup>
import { reactive, toRefs } from 'vue'

const user = reactive({
  email: '',
  password: ''
})

const { email, password } = toRefs(user)
</script>

<template>
  <input v-model="email" />
  <input v-model="password" />
</template>
```

This allows direct use of destructured fields in `v-model`.

---

## ⚠️ When *Not* to Use `toRefs()`

- When not destructuring (`user.email` is fine on its own)
- For standalone `ref()`s (no need to wrap again)
- For very flat state (minimal gain)

---

## 🧠 Summary

| Feature       | Description                                   |
|---------------|-----------------------------------------------|
| Input         | A reactive object                             |
| Output        | An object of `ref()`s                         |
| Use case      | Preserve reactivity after destructuring       |
| When to avoid | Simple state or when not destructuring        |

---
