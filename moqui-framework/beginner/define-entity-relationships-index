Learning objectives
- Creating an Entity with Indexes and relationships like one-to-one mapping, one-nofk,etc.
- Creating a simple view entity, understanding its relationships and applying aggregatre funtions.
- Understanding how view entity is translated in Moqui.
- Understanding using sub queries in a view entity. Ex- Shopify Inventory Feed.
- Understanding maps and lists preparation in Moqui.

Prerequisite
Complete developing resp api assignment.

Task 1: Define entities

order_header, order_item entity as per the definition given below.
```
{
  "table": "order_header",
  "columns": [
    {
      "name": "order_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true
      }
    },
    {
      "name": "order_name",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "placed_date",
      "type": "DATETIME",
      "default": null
    },
    {
      "name": "approved_date",
      "type": "DATETIME",
      "default": null
    },
    {
      "name": "status_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "party_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "currency_uom_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "product_store_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "sales_channel_enum_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "grand_total",
      "type": "DECIMAL(24,4)",
      "default": null
    },
    {
      "name": "completed_date",
      "type": "DATETIME",
      "default": null
    }
  ],
  "primaryKey": ["order_id"],
  "foreignKeys": [
    {
      "name": "order_customer_fk",
      "columns": ["party_id"],
      "references": {
        "table": "party",
        "columns": ["party_id"]
      }
    }
  ]
}
```


```
{
  "table": "order_item",
  "columns": [
    {
      "name": "order_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true
      }
    },
    {
      "name": "order_item_seq_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true
      }
    },
    {
      "name": "product_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "item_description",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "quantity",
      "type": "DECIMAL(24,4)",
      "default": null
    },
    {
      "name": "unit_amount",
      "type": "DECIMAL(24,4)",
      "default": null
    },
    {
      "name": "item_type_enum_id",
      "type": "VARCHAR(20)",
      "default": null
    }
  ],
  "primaryKey": ["order_id", "order_item_seq_id"],
  "foreignKeys": [
    {
      "name": "order_item_order_fk",
      "columns": ["order_id"],
      "references": {
        "table": "order_header",
        "columns": ["order_id"]
      }
    },
    {
      "name": "order_item_product_fk",
      "columns": ["product_id"],
      "references": {
        "table": "product",
        "columns": ["product_id"]
      }
    }
  ]
}
```

```
{
  "table": "party",
  "columns": [
    {
      "name": "party_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true,
      }
    },
    {
      "name": "party_enum_type_id",
      "type": "VARCHAR(20)",
      "default": null
    }
  ],
  "primaryKey": ["party_id"]
}
```

```
{
  "table": "person",
  "columns": [
    {
      "name": "party_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true
      }
    },
    {
      "name": "first_name",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "middle_name",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "last_name",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "gender",
      "type": "CHAR(1)",
      "default": null
    },
    {
      "name": "birth_date",
      "type": "DATE",
      "default": null
    },
    {
      "name": "marital_status_enum_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "employment_status_enum_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "occupation",
      "type": "VARCHAR(255)",
      "default": null
    }
  ],
  "primaryKey": ["party_id"],
  "foreignKeys": [
    {
      "name": "person_ibfk_1",
      "columns": ["party_id"],
      "references": {
        "table": "party",
        "columns": ["party_id"]
      }
    }
  ]
}
```

```
{
  "table": "product",
  "columns": [
    {
      "name": "product_id",
      "type": "VARCHAR(20)",
      "constraints": {
        "notNull": true,
      }
    },
    {
      "name": "party_id",
      "type": "VARCHAR(20)",
      "default": null
    },
    {
      "name": "product_name",
      "type": "VARCHAR(255)",
      "default": null
    },
    {
      "name": "description",
      "type": "VARCHAR(1000)",
      "default": null
    },
    {
      "name": "charge_shipping",
      "type": "CHAR(1)",
      "default": null
    },
    {
      "name": "returnable",
      "type": "CHAR(1)",
      "default": null
    }
  ],
  "primaryKey": ["product_id"],
  "foreignKeys": [
    {
      "name": "product_owner_fk",
      "columns": ["party_id"],
      "references": {
        "table": "party",
        "columns": ["party_id"]
      }
    }
  ]
}
```

Sample data


```
{
  "party": {
    "partyId": "P1001",
    "partyTypeEnumId": "PERSON",
    "person": {
      "party_id": 1,
      "first_name": "Alice",
      "middle_name": "Marie",
      "last_name": "Smith",
      "gender": "F",
      "birth_date": "1995-08-20",
      "marital_status_enum_id": "SINGLE",
      "employment_status_enum_id": "EMPLOYED",
      "occupation": "Data Scientist"
    }
  }
}
```

```
{
  "party": {
    "partyId": "P1002",
    "partyTypeEnumId": "PERSON",
    "person": {
      "party_id": 1,
      "first_name": "Joe",
      "middle_name": "D",
      "last_name": "Jackson",
      "gender": "M",
      "birth_date": "1998-08-23",
      "marital_status_enum_id": "SINGLE",
      "employment_status_enum_id": "EMPLOYED",
      "occupation": "Data Scientist"
    }
  }
}
```

```
"Product": {
  "product_id": PD1001,
  "party_id": P1001,
  "product_name": "Smartphone X",
  "description": "High-end smartphone with advanced features",
  "charge_shipping": "Y",
  "returnable": "Y"
}
 "Product": {
  "product_id": PD1002,
  "party_id": P1002,
  "product_name": "Laptop Pro",
  "description": "Powerful laptop for professional use",
  "charge_shipping": "Y",
  "returnable": "Y"
}
 "Product": {
  "product_id": PD1003,
  "party_id": P1003,
  "product_name": "Mac Book",
  "description": "High-end device with advanced features",
  "charge_shipping": "Y",
  "returnable": "N"
}
```