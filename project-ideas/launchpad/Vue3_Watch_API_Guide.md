# 👀 Vue 3 `watch()` API — Full Guide for Java/Moqui Developers

This document explains the use of Vue 3’s `watch()` function in the Composition API, including real-world examples and best practices, tailored for developers transitioning from enterprise Java frameworks like Moqui.

---

## 🧠 What is `watch()`?

`watch()` lets you run custom logic when a **reactive value changes** — similar to a Java `PropertyChangeListener` or an event callback.

```ts
import { ref, watch } from 'vue'

const count = ref(0)

watch(count, (newVal, oldVal) => {
  console.log(`Count changed from ${oldVal} to ${newVal}`)
})
```

---

## 🔁 Basic Behavior

- Accepts a **reactive source** (like a `ref`, `reactive`, or computed value)
- Executes a **callback** when the value changes
- Callback receives `newVal` and `oldVal` as arguments

```ts
watch(selectedUserId, async (newId) => {
  if (newId) {
    const response = await axios.get(`/api/users/${newId}`)
    userProfile.value = response.data
  } else {
    userProfile.value = null
  }
})
```

---

## 🧪 Example: Watching User Selection to Fetch API

```vue
<script setup lang="ts">
import { ref, watch } from 'vue'
import axios from 'axios'

const selectedUserId = ref('')
const userProfile = ref<any>(null)

watch(selectedUserId, async (newId) => {
  if (newId) {
    const response = await axios.get(`/api/users/${newId}`)
    userProfile.value = response.data
  }
})
</script>
```

### 🔍 What’s happening:
- `watch()` observes `selectedUserId`
- Runs the callback any time `selectedUserId.value` changes
- Makes API call and updates `userProfile`

---

## 📌 Advanced Options

### 1. `immediate: true`
Run watcher **immediately** when the component is mounted:

```ts
watch(someValue, callbackFn, { immediate: true })
```

### 2. `deep: true`
Track **nested changes** in a `reactive` object:

```ts
const user = reactive({ name: 'Anil', address: { city: 'NYC' } })

watch(user, (newVal) => {
  console.log('User changed:', newVal)
}, { deep: true })
```

### 3. Watching Multiple Sources

```ts
watch([firstName, lastName], ([newFirst, newLast], [oldFirst, oldLast]) => {
  console.log(`Changed: ${oldFirst} ${oldLast} → ${newFirst} ${newLast}`)
})
```

### 4. Cleanup with `onInvalidate`
Avoid race conditions in async code:

```ts
watch(searchQuery, async (query, _, onInvalidate) => {
  let cancelled = false
  onInvalidate(() => cancelled = true)

  const results = await fetchResults(query)
  if (!cancelled) searchResults.value = results
})
```

---

## 🔄 `watch()` vs `computed()`

| Feature     | `watch()`                                | `computed()`                    |
|-------------|--------------------------------------------|----------------------------------|
| Triggers    | On data change                            | On-demand, when accessed         |
| Purpose     | Run side effects (API, logs, etc.)        | Return a derived reactive value  |
| Returns     | Nothing (runs logic)                      | A reactive value                 |

---

## 🛠️ Best Practices

| Situation                       | Recommendation                          |
|--------------------------------|-----------------------------------------|
| Run logic on init              | Use `immediate: true`                   |
| Observe deeply nested objects  | Use `deep: true`                        |
| Watch more than one value      | Pass an array as first argument         |
| Avoid async race conditions    | Use `onInvalidate` inside async watcher |
| Destructure carefully          | Use `toRefs()` if needed                |

---
