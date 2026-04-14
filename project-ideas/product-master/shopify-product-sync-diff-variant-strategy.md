# Shopify Product Sync – Diff & Variant Strategy Summary

## 1. Objective
Build a resource‑friendly batch job that reads the ~100 k‑line Shopify product JSONL, detects **added/removed variants** and other field‑level changes, and records them so OMS can update Virtual→Variant associations with minimal impact on live order capture.

---

## 2. End‑to‑End Flow (per run)
1. For each Product:
   - Compute **variantSetHash** (SHA‑256 of sorted variant IDs).
   - Quick‑skip if hash unchanged since last run.
   - Otherwise build `added` / `removed` sets and field‑level diffs.
   - Persist one row in `ProductUpdateHistory`.
   - Upsert baseline row in `ProductUpdateHistory`.

---

## 3. Entities & Key Fields
### 3.1 ProductUpdateHistory _(single‑row tracker & baseline)_

> **Purpose:** Stores the latest snapshot **and** any detected diff for each Shopify product *or* variant.

| Column                  | Purpose                                                                                                          |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **productId** (PK)      | Shopify product **or variant** GID (tracks both parent and child)                                                |
| **systemMessageId**     | System message that triggered the update                                                                         |
| **assocs**              | Comma-separated variant product IDs (only for virtual products)                                                  |
| **assocsHash**          | SHA-256 hash of `assocs`                                                                                         |
| **price**               | Numeric price captured for variant rows (Shopify `variants[].price`)                                             |
| **parentProductId**     | Virtual‑product GID for **variant** rows; empty for virtual products                                             |
| **features**            | Flattened option selections (e.g., `1/Size/S`)                                                                   |
| **featuresHash**        | SHA-256 hash of `features`                                                                                       |
| **identifications**     | Map of identifiers such as id, sku, barcode                                                                      |
| **identificationsHash** | SHA-256 hash of `identifications`                                                                                |
| **metafields**          | Flattened metafield entries (`key/namespace/value`)                                                              |
| **metafieldsHash**      | SHA-256 hash of `metafields`                                                                                     |
| **productHash**         | SHA-256 hash of core product fields (title, handle, image, gift card etc.)                                       |
| **tags**                | Flattened tags as key/value strings                                                                              |
| **tagsHash**            | SHA-256 hash of `tags`                                                                                           |
| **differenceMap**       | Full diff JSON for changed fields, tags, features, metafields, assocs, identifications, and nested variant diffs |

#### Moqui Entity XML
```xml
<entity entity-name="ProductUpdateHistory" package="co.hotwax.product">
    <field name="productId" type="id" is-pk="true">
        <description>Shopify Product ID (used for both virtual and variant products)</description>
    </field>
    <field name="systemMessageId" type="id" not-null="true"/>
    <field name="assocs" type="text-long">
        <description>
            For virtual products, a comma-separated list of associated variant product Shopify IDs.
            For variant products, it will be empty.
        </description>
    </field>
    <field name="assocsHash" type="text-intermediate"/>
    <field name="price" type="currency-precise"/>
    <field name="parentProductId" type="id">
        <description>
            The Shopify Product ID of the parent product for variant products. For virtual products, it will be empty.
            It's kept separate from assocs to store the virtual product id as a String.
        </description>
    </field>
    <field name="features" type="text-very-long">
        <description>
            A List of selected options or features of the product (e.g., 1/Size/S, 1/Size/M, 1/Color/Red).
        </description>
    </field>
    <field name="featuresHash" type="text-intermediate"/>
    <field name="identifications" type="text-long">
        <description>
            A map of identifying attributes such as 'id', 'sku', and 'barcode'.
        </description>
    </field>
    <field name="identificationsHash" type="text-intermediate"/>
    <field name="metafields" type="text-very-long">
        <description>
            Flattened metafield entries in the format "key/namespace/value", stored as a list.
        </description>
    </field>
    <field name="metafieldsHash" type="text-intermediate"/>
    <field name="productHash" type="text-intermediate">
        <description>
            SHA256 Hash representing the product’s core details (title, handle, image, gift card, etc.).
        </description>
    </field>
    <field name="tags" type="text-very-long">
        <description>
            Categorization or label tags of the product, flattened as key/value strings.
        </description>
    </field>
    <field name="tagsHash" type="text-intermediate"/>
    <field name="differenceMap" type="text-very-long">
        <description>
            A complete diff of the product’s changed fields including tags, features, metafields, assocs, identifications,
            and nested differences in associated variants. Stored as JSON.
        </description>
    </field>
</entity>
```

### 3.2 Parent/Virtual Product – Tracked & Compared Attributes
| Shopify Source Field | Canonical (HC) Field | Notes |
|----------------------|----------------------|-------|
| `title` | `Product.productName` | Display name shown to shoppers |
| `handle` | `Product.internalName` | URL slug / style code |
| `productType` & `hasVariantsThatRequiresComponents` | `Product.productTypeId` | Map to `FINISHED_GOOD` or `DIGITAL_GOOD` |
| `vendor` | `Product.manufacturerPartyId` | Optional; can be a Party lookup |
| `category.fullName` | `Product.primaryCategory` | Stored as text or FK to Catalog |
| `featuredMedia.preview.image.url` | `Product.detailImageUrl` | Fallback to first variant image if null |
| `tags[]` | `ProductKeywordNew.keyword` | Colon‑pairs optionally parsed into features |
| `options[].name` | `ProductFeatureType.description` | e.g. Size, Color |
| `options[].optionValues[].name` | `ProductFeature.description` | Values map via `ProductFeatureAppl` |
| Metafields (`title_en`, `body_html_en`, etc.) | `ProductContent` rows | **Metafields only exist on parent products — ignored for variant diffs** |

### 3.3 Variant Product – Tracked & Compared Attributes
| Shopify Source Field | Stored Column | Notes |
|----------------------|--------------|-------|
| `variants[].price` | `price` | Numeric; compared for change |
| `sku`, `barcode`, `id` | `identifications` (detailJson) | No separate columns yet |
| Parent GID (`product.id`) | `parentProductId` | Used to link variant to its style |
| Selected options | `features` (detailJson) | Size/Color etc. |

## 4. `detailJson` Shape for Variants & Tags
```json
{
  "variants": {
    "added"  : ["gid://…/47228375699999"],
    "removed": ["gid://…/47228375531804"]
  },
  "tags": {
    "added"  : ["markdown:Yes"],
    "removed": ["markdown:No"]
  },
  "features": {
    "Size":  { "added": ["XXL"], "removed": [] }
  }
}
```
Downstream loaders inspect `detailJson` only; no separate Y/N flags are required.

---

## 5. Performance Guardrails
| Tactic | Why |
|--------|-----|
| **Streaming parser** | Avoids 100 k‑line heap load. |
| **Variant set hash** | Skip >90 % unchanged parents. |
| **LRU cache** for `ProductUpdateHistory` | One DB read per new parent. |
| **Batch writes (250 parents)** | Keeps InnoDB log contention low. |
| **Optional throttle** (`sleep 20 ms`) | Yields CPU during checkout peaks. |

---

## 6. Open Decisions
1. **Variant key** – use Shopify variant GID (`gid://…/ProductVariant/...`) or SKU?  _(Hash must be stable.)_
2. **Baseline storage** – reuse `ProductUpdateHistory` vs. new `ShopifyProductVariantSnapshot`?
3. **Batch size & throttle** – 250 & 20 ms OK?
4. **Downstream format** – is `detailJson` sufficient or need separate file export?

---

## 7. Implementation To‑Dos
- [ ] Extend `ProductUpdateHistory` (add `variantIdsCsv`, `variantSetHash`).
- [ ] Patch flush logic in `transform#JsonLToJsonForUpdatedProducts`:
  * compute variant set & hash
  * skip or diff as per §2
  * always refresh baseline row
- [ ] Unit tests: no‑change, add variant, remove variant, add + remove.
- [ ] Load & monitor metrics (`runtime/log/shopify-sync-metrics.json`).

---
