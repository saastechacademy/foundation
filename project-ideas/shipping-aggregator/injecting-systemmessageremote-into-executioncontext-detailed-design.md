# Injecting SystemMessageRemote into ExecutionContext: Detailed Design

---

## 1. Moqui Framework Extensibility Using Tools

In the Moqui Framework, the `tool` mechanism provides a standard way to extend the `ExecutionContext` (`ec`) with custom helper objects.

- Tools are initialized once per `ExecutionContext` instance.
- Tools are available through `ec.tool.[toolName]`.
- Tools are configured in `MoquiConf.xml` under the `<tools>` section.
- Tools allow reusable logic or context-specific data to be easily accessible in all services, screens, and scripts.

Examples of built-in Moqui tools:
- `l10n` (localization support)

Custom tools follow the same approach, extending the runtime cleanly.

---

## 2. Purpose of SystemMessageRemoteTool

The `SystemMessageRemoteTool` will:

- Resolve and inject the tenant’s `SystemMessageRemote` entity into the `ExecutionContext`.
- Make it available via `ec.tool.systemMessageRemoteTool.getSystemMessageRemote()`.
- Simplify service logic by avoiding repeated credential lookups.

---

## 3. Specification for Implementation

### 3.1 Tool Class

| Item | Details |
|:-----|:--------|
| **Class Name** | `SystemMessageRemoteTool` |
| **Package** | Example: `shipping.gateway.tool` |
| **Type** | Groovy or Java class |
| **Interface** | Regular POJO using `ExecutionContext` |

---

### 3.2 Tool Registration

Register the tool in `MoquiConf.xml`:

```xml
<tool class="shipping.gateway.tool.SystemMessageRemoteTool" name="systemMessageRemoteTool"/>
```

It becomes accessible in Moqui through:

```groovy
ec.tool.systemMessageRemoteTool
```

---

### 3.3 Responsibilities

| Responsibility | Details |
|:---------------|:--------|
| Initialization | Load `SystemMessageRemote` on first access per request. |
| Input | `tenantPartyId` and `shippingGatewayConfigId` extracted from `ec.user`. |
| Lookup | Query `SystemMessageRemote` where `tenantPartyId` and `systemMessageRemoteTypeEnumId` match. |
| Accessor | `getSystemMessageRemote()` method. |
| Error Handling | Throw clear error if lookup fails. |

---

### 3.4 Tool Behavior Summary

```plaintext
On first call to getSystemMessageRemote():
    ↓
If already cached, return
    ↓
Else lookup SystemMessageRemote by tenantPartyId and systemMessageRemoteTypeEnumId
    ↓
Cache it for rest of ExecutionContext lifecycle
    ↓
Return instance
```

---

### 3.5 Example Code Sketch

#### Class Definition

```groovy
class SystemMessageRemoteTool {
    protected ExecutionContext ec
    protected SystemMessageRemote systemMessageRemote

    SystemMessageRemoteTool(ExecutionContext ec) {
        this.ec = ec
    }
```

#### Method: getSystemMessageRemote

```groovy
    SystemMessageRemote getSystemMessageRemote() {
        if (systemMessageRemote != null) return systemMessageRemote

        String tenantPartyId = ec.user.getTenantId()
        String gatewayConfigId = ec.user.getGatewayConfigId()

        systemMessageRemote = ec.entity.find("shipping.gateway.SystemMessageRemote")
            .condition("tenantPartyId", tenantPartyId)
            .condition("systemMessageRemoteTypeEnumId", gatewayConfigId)
            .useCache(true)
            .one()

        if (!systemMessageRemote) {
            throw new IllegalArgumentException("No SystemMessageRemote found for tenant ${tenantPartyId} and gateway ${gatewayConfigId}")
        }

        return systemMessageRemote
    }
}
```

---

### 3.6 Context Handling (Moqui Best Practices)

- JWT parsing and tenant identification are handled during authentication.
- A custom `AuthzRealm` can be implemented if needed.
- `tenantPartyId` and `shippingGatewayConfigId` should be populated into `ec.user` attributes at login.
- Application services retrieve them using `ec.user.getTenantId()` and `ec.user.getGatewayConfigId()`, without manually parsing JWT tokens during service execution.

This ensures consistent, secure, and efficient tenant context management across the application.

---

# Conclusion

The `SystemMessageRemoteTool` integrates tenant-specific shipping credentials into the Moqui ExecutionContext, simplifying credential access and promoting a clean, modular service structure suitable for multi-tenant shipping gateway operations.
