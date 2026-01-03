## Detail Design: Schema Loading and Query Validation (graphql-java)

### Goal
Describe how we will load the Shopify SDL from the root `resources/` folder and validate a query AST against that schema using graphql-java.

---

### 1) Schema Loading

#### Steps
1) Read the SDL file from `resources/shopify-order-subset.graphqls`.
2) Parse SDL into a `TypeDefinitionRegistry`.
3) Build a `GraphQLSchema` using `SchemaGenerator`.

#### Java Example (graphql-java)
```java
import graphql.schema.GraphQLSchema;
import graphql.schema.idl.SchemaParser;
import graphql.schema.idl.SchemaGenerator;
import graphql.schema.idl.TypeDefinitionRegistry;
import graphql.schema.idl.RuntimeWiring;

import java.nio.file.Files;
import java.nio.file.Path;

public class SchemaLoader {
    public static GraphQLSchema loadSchema(Path sdlPath) throws Exception {
        String sdl = Files.readString(sdlPath);
        TypeDefinitionRegistry registry = new SchemaParser().parse(sdl);
        RuntimeWiring wiring = RuntimeWiring.newRuntimeWiring().build();
        return new SchemaGenerator().makeExecutableSchema(registry, wiring);
    }
}
```

Notes:
- We are not executing queries, so we do not define data fetchers.
- For validation-only, we may use a minimal `RuntimeWiring` or an empty wiring if required by the chosen graphql-java version.

---

### 2) Query Validation

#### Steps
1) Build a `Document` AST for the query (as shown in the query design doc).
2) Run graphql-java validation against the schema.
3) Capture and return validation errors.

#### Java Example (graphql-java)
```java
import graphql.language.Document;
import graphql.validation.Validator;
import graphql.validation.ValidationError;
import graphql.schema.GraphQLSchema;

import java.util.List;

public class QueryValidator {
    public static List<ValidationError> validate(GraphQLSchema schema, Document document) {
        Validator validator = new Validator();
        return validator.validateDocument(schema, document);
    }
}
```

Notes:
- Validation errors should be returned to the caller alongside the query output.
- We should validate before serialization to catch schema mismatches early.
- The exact validation signature can vary slightly by graphql-java version; align with the chosen version during implementation.
