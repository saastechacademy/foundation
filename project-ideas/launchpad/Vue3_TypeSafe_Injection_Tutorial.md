# 🧠 Vue 3 Type-Safe Injection Tutorial

This guide explains how to use **type-safe injection** in Vue 3 using Composition API. We will use a real-world example: providing a `bootstrapContext` that contains authentication and configuration data.

---

## 🔍 What is Type-Safe Injection?

Vue's `provide()` and `inject()` API lets you share data from parent to child components without prop drilling. But if you don’t use it carefully, TypeScript won’t know the shape of what you're injecting.

**Type-safe injection** means:
- You clearly define the type of your injected object.
- TypeScript can infer and enforce the structure of the injected value.
- You get full autocompletion and compile-time safety.

---

## 🧪 Problem Without Type Safety

```ts
const context = inject('bootstrapContext')
// ❌ TypeScript says: any | undefined
```

You won’t get suggestions or errors if you mistype `context.token` or forget a field.

---

## ✅ Solution: Use `InjectionKey<T>`

### Step 1: Define the Interface

```ts
interface BootstrapContext {
  token: string;
  oms: string;
  currentUser: any;
  permissions: string[];
}
```

### Step 2: Create an `InjectionKey`

```ts
import { InjectionKey } from 'vue'

const BootstrapKey: InjectionKey<BootstrapContext> = Symbol('BootstrapContext')
```

This special `InjectionKey<T>` makes the symbol type-aware.

---

## 💡 Full Example: bootstrapContext.ts

```ts
import { inject, provide, reactive, InjectionKey } from 'vue'

interface BootstrapContext {
  token: string;
  oms: string;
  currentUser: any;
  permissions: string[];
}

const BootstrapKey: InjectionKey<BootstrapContext> = Symbol('BootstrapContext')

export function provideBootstrapContext(context: BootstrapContext) {
  provide(BootstrapKey, reactive(context))
}

export function useBootstrapContext(): BootstrapContext {
  const context = inject(BootstrapKey)
  if (!context) {
    throw new Error('BootstrapContext not provided!')
  }
  return context
}
```

---

## 🧠 How It Helps

| Feature                | Benefit                                   |
|------------------------|-------------------------------------------|
| `InjectionKey<T>`      | Ensures the value injected has type `T`    |
| `Symbol()`             | Prevents key collisions                   |
| Error if not provided | Protects against undefined usage          |
| IDE Support           | Shows autocompletion and type hints       |

---

## ✅ Summary

- Use `InjectionKey<T>` instead of plain strings for inject keys.
- Use `Symbol()` to generate unique, collision-safe keys.
- Use runtime guards (`if (!context) throw`) to ensure reliability.

This pattern is ideal for shared state like `authStore`, `bootstrapContext`, and system config across apps like Launchpad, HCApps, and Inventory Count.
