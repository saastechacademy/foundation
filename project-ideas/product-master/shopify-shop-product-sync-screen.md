# ShopifyShop Product Sync Screen

## Purpose
Add product sync management to the `ShopifyShop` screen so an OMS user can:

- understand whether product sync is configured for a shop
- trigger an initial or incremental Shopify to OMS product sync
- monitor the latest sync status across all processing stages
- review failures and retry safely

This screen is a control and monitoring layer for the backend workflow documented in [shopify-product-sync-workflow.md](shopify-product-sync-workflow.md) and [sync-shopify-product-updates-design.md](sync-shopify-product-updates-design.md).

## User Goal
From a single Shopify shop record, the user should be able to manage the full product import lifecycle without needing to manually inspect scheduled jobs, system messages, or MDM import records in separate screens.

## Lifecycle Model
The UI should present product sync as three linked parts of one run:

1. `Scheduler Run`
2. `SystemMessage Lifecycle`
3. `MDM Import Lifecycle`

Each part has its own status, timestamps, and errors, but the user must see them together in sequence for the same shop and sync request.

### 1. Scheduler Run
This is the Moqui scheduled execution of `sync#ShopifyProductUpdates`.

#### Responsibility
- decide when product sync should run
- invoke `sync#ShopifyProductUpdates`
- create a `BulkQueryShopifyProductUpdates` system message

#### User visibility
- scheduled job name
- last run date/time
- next run date/time
- last run result
- who triggered the run (`System`, `User`, or scheduler name)
- generated `SystemMessageId` if creation succeeded
- job-level error if the scheduler run failed before message creation

### 2. SystemMessage Lifecycle
This starts after the scheduled job successfully creates `BulkQueryShopifyProductUpdates`.

#### Responsibility
- queue and send Shopify bulk query
- wait for Shopify bulk operation completion
- download the bulk result file
- hand the file over for downstream consume / import preparation

#### User visibility
- `SystemMessageId`
- `SystemMessageTypeId`
- current status
- remote Shopify bulk operation ID
- created, sent, received, consumed, confirmed timestamps
- downloaded file path/name
- system-message level errors

### 3. MDM Import Lifecycle
This starts after the bulk data file is handed off from the `SystemMessage` processing flow to MDM.

#### Responsibility
- process each product record from the bulk file
- create/update records in MDM/OMS
- record import-level failures for rejected records

#### User visibility
- MDM import job ID
- import status
- import start/completion timestamps
- total records
- processed records
- successful records
- errored records
- downloadable error file or error-record list
- final import outcome

## Screen Placement
Add a new section on the `ShopifyShop` detail screen:

- section title: `Product Sync`
- placement: same level as other shop-level integration controls
- scope: one shop at a time, driven by `shopId`

## Primary Screen Structure
The `Product Sync` section should be run-centric, not entity-centric.

### 1. Summary Card
The top of the section should show the latest overall product sync state for the selected shop.

### Fields
- `Overall sync status`
- `Last successful sync date`
- `Current active run`
- `Last scheduler run date`
- `Last system message ID`
- `Last MDM import ID`
- `Last file processed`
- `Products created`
- `Products updated`
- `Variants added`
- `Variants removed`
- `Error summary`

### Status values

Overall status should be derived from the latest linked scheduler run, product-sync `SystemMessage`, and MDM import execution for the shop.

### 2. Current Run Timeline
Directly below the summary card, show one horizontal or vertical timeline with three stages:

1. `Scheduled`
2. `Bulk Query`
3. `MDM Import`

Each stage should show:

- status badge
- started/completed timestamps
- primary identifier
- short error text if failed

### 3. Lifecycle Panels
Below the timeline, show three expandable panels so the user can inspect each part in detail:

- `Scheduler Run`
- `SystemMessage`
- `MDM Import`

## User Actions

### 1. Run Initial Sync
Used when the shop has never imported products into OMS or when the user intentionally wants a full rebuild baseline.

#### Behavior
- button label: `Run Initial Sync`
- triggers `sync#ShopifyProductUpdates` for the current `shopifyShopId`
- runs with no `fromDate` so Shopify returns the full product catalog
- the service run should create a `BulkQueryShopifyProductUpdates` system message
- disabled while another product sync run is already `Queued`, `Running`, or `Awaiting Import`

#### Confirmation text
`This will queue a full product import from Shopify for this shop.`

### 2. Run Incremental Sync
Used for regular operational sync after the baseline is established.

#### Inputs
- optional `From Date`
- optional `Thru Date`
- optional `Namespaces`

#### Behavior
- button label: `Run Incremental Sync`
- default `From Date` should be the last successful sync completion timestamp
- user may override the date range
- triggers `sync#ShopifyProductUpdates` using the selected filters
- the service run should create a `BulkQueryShopifyProductUpdates` system message
- disabled while another product sync is already active

#### Row actions
- `View Details`
- `Retry`
- `Download Error Log`


### Validate Required prerequisites
- `ShopifyShop` exists and is active
- linked Shopify credentials/config are available
- product sync GraphQL access scope is available
- `SystemMessageType = BulkQueryShopifyProductUpdates` is configured
- `receiveMovePath` is configured for the product sync message type or parent type

### Validation messaging
Show a clear blocking banner, for example:

- `Shop credentials are missing. Product sync cannot be started.`
- `Product sync message type is not configured.`
- `No receive path is configured for Shopify bulk product files.`

## Recommended Screen Flow

### First-time setup
1. User opens `ShopifyShop`
2. `Product Sync` section shows `Not configured` or `Ready`
3. User reviews prerequisites
4. User clicks `Run Initial Sync`
5. UI shows scheduler run details and generated system message
6. UI shows `Queued`, then `Running`
7. After system message completes, UI shows MDM import progress
8. After import processing completes, status changes to `Succeeded` or `Completed With Errors`

### Routine operation
1. User opens `ShopifyShop`
2. UI shows last successful sync and health summary
3. User clicks `Run Incremental Sync` or waits for a scheduled sync
4. UI reflects scheduler, bulk query, and MDM statuses in one run timeline

### Failure handling
1. Sync status becomes `Failed`
2. Screen surfaces which stage failed: scheduler, system message, or MDM import
3. User opens details, reviews the message, and clicks `Retry`

## Lifecycle Detail

### Scheduler Run Panel
Show details for the execution of `sync#ShopifyProductUpdates`.

#### Fields
- `Run type`
- `Triggered by`
- `Triggered at`
- `Scheduler job name`
- `Run status`
- `Input parameters`
- `Created SystemMessageId`
- `Failure reason`

#### Run statuses
- `Pending`
- `Running`
- `Succeeded`
- `Failed`

### SystemMessage Panel
Show details for the `BulkQueryShopifyProductUpdates` message linked to the selected run.

#### Fields
- `SystemMessageId`
- `SystemMessageTypeId`
- `Status`
- `Remote message ID`
- `Created at`
- `Last attempt at`
- `Received at`
- `Consumed at`
- `Confirmed at`
- `Downloaded file`
- `Error details`

### Queued
- system message exists in `SmsgProduced`
- show informational text: `Sync request created and waiting to be sent to Shopify.`

### Running
- system message is `SmsgSent`
- remote Shopify bulk operation exists
- show remote operation ID if available

### Processing
- system message is `SmsgReceived` or `SmsgConsuming`
- file is downloaded and being handed off for downstream import

### Succeeded
- system message reaches `SmsgConfirmed`
- expose file handoff details

### Failed
- system message reaches `SmsgError` or `SmsgRejected`
- show latest `SystemMessageError`
- provide retry action

### MDM Import Panel
Show details for the import execution started from the consumed bulk file.

#### Fields
- `Import job ID`
- `Import status`
- `Started at`
- `Completed at`
- `Input file`
- `Total records`
- `Processed records`
- `Successful records`
- `Errored records`
- `Error file / rejected records`
- `Import summary`

### Correlation requirement
The three parts must be linked by a correlation key so the UI can reconstruct one run end to end.

Recommended correlation chain:

- scheduler run ID
- created `systemMessageId`
- downstream MDM import job ID


## Open Questions
- Should product sync run only on demand from the screen, or also be schedulable per shop from the same section?
- Do we want separate actions for `Full Resync` and `Initial Sync`, or should one action cover both?
- What entity should represent the scheduler execution so UI can show job-level status before `SystemMessage` creation?
- Where should the correlation ID be persisted so scheduler, `SystemMessage`, and MDM import records can be linked reliably?
- Should retry resume a failed consume/import stage, or always create a new end-to-end sync request?
