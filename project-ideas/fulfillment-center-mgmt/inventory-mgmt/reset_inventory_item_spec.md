# Inventory Reset Item Specification

## Overview

The inventory reset flow is split into:

- `reset#InventoryItem`
- `create#ExternalInventoryReset`

`reset#InventoryItem` is the shared decision service.
`create#ExternalInventoryReset` is the persistence service.

Custom components should not directly own the reset logic. They should create thin wrapper services for their external file or API shape, and those wrappers should call `reset#InventoryItem`.

Example wrapper:

- `process#NetSuiteInventoryReset`

## `reset#InventoryItem`

### Purpose

This service:

- resolves the facility, product, and inventory item
- reads the current internal ATP and QOH
- computes the variance against the external quantity
- decides whether a reset is required
- calls `create#ExternalInventoryReset` only when the diff is non-zero

### Input

```json
{
  "resetDateResourceId": "RDR12345",
  "externalFacilityId": "EXTFAC4321",
  "productIdentType": "SKU",
  "productIdentValue": "SKU-001-A",
  "externalQOH": 180,
  "externalATP": null,
  "reason": "VAR_EXT_RESET",
  "description": "NetSuite"
}
```

Rules:

- exactly one of `externalQOH` or `externalATP` must be passed
- `reason` defaults to `VAR_EXT_RESET`
- `description` is optional

### Resolution

The service uses the standard inventory-item resolution flow to:

- resolve `facilityId`
- resolve `productId`
- resolve or create `inventoryItemId`
- read:
  - `inventoryItemQOH`
  - `inventoryItemATP`

### Diff logic

If `externalQOH` is passed:

```text
quantityOnHandDiff = externalQOH - inventoryItemQOH
availableToPromiseDiff = quantityOnHandDiff
```

If `externalATP` is passed:

```text
availableToPromiseDiff = externalATP - inventoryItemATP
quantityOnHandDiff = availableToPromiseDiff
```

### No-op behavior

If both diffs are zero:

- the service returns the resolved values
- it does not call `create#ExternalInventoryReset`
- it does not create any reset records

### Reset behavior

If either diff is non-zero:

- the service calls `create#ExternalInventoryReset`
- returns the resolved context and `resetItemId`

### Output

#### Diff found

```json
{
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 200,
  "inventoryItemATP": 180,
  "externalQOH": 180,
  "externalATP": null,
  "quantityOnHandDiff": -20,
  "availableToPromiseDiff": -20,
  "resetItemId": "EIR123456"
}
```

#### No diff found

```json
{
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 180,
  "inventoryItemATP": 150,
  "externalQOH": 180,
  "externalATP": null,
  "quantityOnHandDiff": 0,
  "availableToPromiseDiff": 0
}
```

## `create#ExternalInventoryReset`

### Purpose

This service is the persistence layer.

It:

- validates the reset reason
- resolves the inventory item if needed
- recomputes diffs defensively
- skips persistence if the final diff is zero
- creates `ExternalInventoryReset`
- creates `InventoryItemDetail`

### Persisted detail fields

For a non-zero reset, `InventoryItemDetail` includes:

- `inventoryItemId`
- `quantityOnHandDiff`
- `availableToPromiseDiff`
- `accountingQuantityDiff`
- `reasonEnumId`
- `description`
- `resetItemId`

## Wrapper Service Pattern

An external-system-specific wrapper service should:

- adapt incoming attributes to the shared service contract
- determine the right external identifier value
- do any external-system-specific row validation
- call `reset#InventoryItem`
- return a top-level row error if the shared service returns an error

Example:

- wrapper service: `process#NetSuiteInventoryReset`
- shared service: `reset#InventoryItem`
- persistence service: `create#ExternalInventoryReset`

## Sample DataManager Config

```xml
<co.hotwax.datamanager.DataManagerConfig
        configId="EXT_INV_RESET"
        importPath="/home/integration/inventory-reset/csv"
        importServiceName="co.company.inventory.InventoryServices.process#NetSuiteInventoryReset"
        description="Import external inventory reset feed"
        scriptTitle="Import External Inventory Reset"
        executionModeId="DMC_QUEUE"
        multiThreading="N"/>
```

## Sample ServiceJob

```xml
<moqui.service.job.ServiceJob jobName="import_external_inventory_reset"
        description="Import external inventory reset feed"
        serviceName="co.hotwax.util.UtilityServices.get#DataManagerFileFromSftp"
        cronExpression=""
        paused="Y">
    <parameters parameterName="configId" parameterValue="EXT_INV_RESET"/>
    <parameters parameterName="systemMessageRemoteId" parameterValue=""/>
    <parameters parameterName="parameters"
                parameterValue="{&quot;productIdent&quot;:&quot;SKU&quot;,&quot;reason&quot;:&quot;VAR_EXT_RESET&quot;,&quot;description&quot;:&quot;NetSuite&quot;}"/>
</moqui.service.job.ServiceJob>
```

## Design Notes

- `reset#InventoryItem` owns the decision
- `create#ExternalInventoryReset` owns persistence
- wrapper services should stay thin
- zero diff means no-op and no reset record creation
