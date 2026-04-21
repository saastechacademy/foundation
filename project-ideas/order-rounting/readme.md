# Port Order Routing Group Between Environments

---

## 📄 **Description**

Port a configured `OrderRoutingGroup` from one OMS environment to another — such as from UAT to Production for deployment, or from Production to UAT for debugging. This workflow uses export and import operations to ensure consistent, validated routing configurations across environments.

---

## Why Use This XML + Git Approach for `OrderRoutingGroup`

### 1. Git-Friendly Diffs

* XML output is sorted and consistently formatted
* Only real business logic changes appear in `git diff`
* Supports PR-based approval workflows

### 2. Moqui-Compatible Format

* Uses native `<entity-facade-xml type="ext-demo">`
* Import-ready via Moqui data loader

### 3. Structured and Reliable Promotion

* Exports a full `OrderRoutingGroup` and all nested configuration
* Designed for end-to-end promotion from UAT to Production

---

## Best Practices Followed in the FreeMarker Export Template

| Practice                                       | Why It Matters                                |
| ---------------------------------------------- | --------------------------------------------- |
| Consistent field ordering                      | Makes diffs meaningful, reduces noise         |
| Sorted child lists (`?sort_by("sequenceNum")`) | Ensures stable output regardless of DB order  |
| No system metadata                             | Prevents false positives in diffs             |
| One file per `OrderRoutingGroup`               | Modular Git tracking, simplified reviews      |
| XML-escaped values (`?xml`)                    | Prevents malformed output                     |
| No timestamps in filenames                     | Keeps Git history clean and file names stable |
| Clean formatting                               | Improves readability and reduces clutter      |

---

## Resulting Benefits

* **Safe**: Validated and rollback-ready
* **Controlled**: Human review + Git versioning
* **Traceable**: Historical changes fully auditable
* **Reversible**: Easy to revert to previous state with Git

This approach supports a promotion process that is dependable, collaborative, and scalable across environments, with `OrderRoutingGroup` as the primary unit of routing configuration.
