# Shopify Product Sync – Diff & Variant Strategy Summary

## 1. Objective
Build a resource‑friendly batch job that reads the ~100 k‑line Shopify product JSONL, detects **added/removed variants** and other field‑level changes, and records them so OMS can update Virtual→Variant associations with minimal impact on live order capture.

---

## 2. End‑to‑End Flow (per run)
1. **Stream read JSONL** → one line at a time (Jackson `ObjectReader`).
2. **Group by parent product** (Shopify `product.id`).
3. After each parent boundary or at EOF:
   - Compute **variantSetHash** (SHA‑1 of sorted variant IDs).
   - Quick‑skip if hash unchanged since last run.
   - Otherwise build `added` / `removed` sets and field‑level diffs.
   - Persist one row in `ProductUpdateHistory`.
   - Upsert baseline row in `ProductUpdateHistory`.
4. Commit every **250 parents**, optionally sleep 20 ms when `SystemProperty.sync.lowPriority=Y`.

---

## 3. Entities & Key Fields
### 3.1 ProductUpdateHistory _(single‑row tracker & baseline)_

> **Purpose:** Stores the latest snapshot **and** any detected diff for each Shopify product *or* variant.

| Column | Purpose |
|--------|---------|
| **productId** (PK) | Shopify product **or variant** GID (tracks both parent and child) |
| snapshotTs | Timestamp when this snapshot was processed |
| coreHash | SHA‑1 of core parent fields (`title`, `handle`, `productTypeId`, `vendor`, `category`, `detailImageUrl`) |
| tagHash | SHA‑1 of sorted tag list |
| featureHash | SHA‑1 of flattened option→value pairs |
| variantSetHash | SHA‑1 of sorted variant IDs (roster) |
| variantIdsCsv | Comma‑separated list of **current** variant GIDs (only present on **parent** rows) |
| tagsCsv | Comma‑separated tag strings for **parent** rows |
| featuresJson | JSON array of option/value pairs for **parent** rows |
| parentProductId | Virtual‑product GID for **variant** rows; `null` for parents |
| price | Numeric price captured for variant rows (Shopify `variants[].price`) |
| detailJson | JSON blob with added / removed sets and field‑level diffs |

#### Moqui Entity XML
```xml
<entity entity-name="ProductUpdateHistory"
        package-name="co.hotwax.shopifysync"
        table-name="SHOPIFY_PRODUCT_UPDATE_HST"
        pk-field-name="productId"
        datasource-name="localmysql">
    <field name="productId"         type="id"           description="Shopify product or variant GID"/>
    <field name="snapshotTs"        type="date-time"    description="Timestamp of processed snapshot"/>
    <field name="coreHash"          type="indicator"    length="40"/>
    <field name="tagHash"           type="indicator"    length="40"/>
    <field name="featureHash"       type="indicator"    length="40"/>
    <field name="variantSetHash"    type="indicator"    length="40"/>
    <field name="variantIdsCsv"     type="text-long"    description="CSV of current variant GIDs (for parents)"/>
    <field name="tagsCsv"           type="text-long"    description="CSV of tags (parent only)"/>
    <field name="featuresJson"      type="text-long"    description="JSON array of option/value pairs (parent only)"/>
    <field name="parentProductId"   type="id"           description="Parent virtual product GID for variants"/>
    <field name="price"             type="currency-precise" description="Variant price"/>
    <field name="detailJson"        type="text-long"    description="JSON diff payload"/>

    <index name="PuhSnapshotTs" unique="false">
        <index-field name="snapshotTs"/>
    </index>
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
