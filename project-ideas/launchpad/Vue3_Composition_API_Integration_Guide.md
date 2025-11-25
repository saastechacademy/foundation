# 🧩 Vue 3 Composition API — Integrating `ref`, `reactive`, `computed`, `watch`, `toRefs`

This guide shows how all key Composition API features work together in a realistic Vue 3/Ionic PWA module, such as a product editor form.

---

## 🧱 Step-by-Step Breakdown

### 1. ✅ Reactive State with [`reactive()`](Vue3_Reactive_API_Guide.md)

```ts
const product = reactive
  name: '',
  price: 0,
  quantity: 1
})
```

Use `reactive()` for structured form state.

---

### 2. 🎯 Derived Values with [`computed()`](Vue3_Computed_API_Guide.md)

```ts
const subtotal = computed(() => product.price * product.quantity)
```

Auto-updates when `price` or `quantity` changes.

---

### 3. 🧪 Detect Form Changes with [`watch()`](Vue3_Watch_API_Guide.md)

```ts
watch(product, () => {
  console.log('Form has changed — show save prompt?')
}, { deep: true })
```

Use `deep: true` to track nested changes in a reactive object.

---

### 4. 📤 Load Data from API

```ts
const loadProduct = async (id: string) => {
  const data = await axios.get(`/api/products/${id}`)
  Object.assign(product, data)
}
```

Assign loaded data to the reactive object.

---

### 5. 🧬 Use [`toRefs()`](Vue3_toRefs_API_Guide.md) for Template Binding

```ts
const { name, price, quantity } = toRefs(product)
```

Enables `v-model` and individual prop passing without breaking reactivity.

---

## 🧩 Template Example

```vue
<template>
  <form>
    <input v-model="name" />
    <input type="number" v-model="price" />
    <input type="number" v-model="quantity" />
    <p>Subtotal: {{ subtotal }}</p>
  </form>
</template>
```

---

## 🧠 Summary Table

| Feature      | Purpose                                 | Use Case                        |
|--------------|------------------------------------------|----------------------------------|
| `ref()`      | Reactive primitive                       | Flags, counters, booleans        |
| `reactive()` | Reactive object                          | Forms, structured state          |
| `computed()` | Reactive derived values (cached)         | Totals, display logic            |
| `watch()`    | Run side effects on data change          | Autosave, fetch, validation      |
| `toRefs()`   | Preserve reactivity when destructuring   | `v-model`, prop binding          |

---
