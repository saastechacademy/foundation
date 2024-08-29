## Introduction to Mantle Business Artifacts

Mantle is a collection of business artifacts built on top of the Moqui Framework, designed to accelerate the development of common business applications.

### Introduction to Mantle Components

* **Mantle UDM (Universal Data Model):** Provides a standardized data model for common business entities and concepts.
* **Mantle USL (Universal Service Layer):** Offers reusable services for common business tasks, such as order management, inventory control, and customer relationship management.
* **Order and Product Artifacts:** These artifacts specifically handle order processing, product management, and related processes.

### Tracing Existing Services and Entities

Familiarize yourself with existing Moqui services and entities by exploring their implementations and usage in the framework's codebase. This will help you leverage the existing functionality when building your own services.

### Framework Setup for Development

1. **Open a Terminal:** Launch your terminal application.
2. **Sandbox Directory:** Navigate to your development directory (e.g., `~/sandbox`).
3. **Clone Repository:** Clone the Moqui framework:
   ```bash
   git clone -b master https://github.com/moqui/moqui-framework.git
   ```
4. **Add Runtime:**
   ```bash
   cd moqui-framework
   ./gradlew getRuntime
   ```
5. **Clone Components:** Navigate to the `moqui-framework/runtime/component` directory and clone the following components:
   ```bash
   git clone -b master https://github.com/moqui/mantle-usl.git
   git clone -b master https://github.com/moqui/mantle-udm.git
   git clone -b master https://github.com/moqui/SimpleScreens.git
   git clone -b master https://github.com/moqui/moqui-fop.git
   git clone -b master https://github.com/moqui/PopCommerce.git
   ```

## Assignment

### Tasks

#### 1. Create a New Product Service (Part A)

1.  **Input Parameters:**
    *   `productName`
    *   `description`
    *   `price` (optional)
    *   `priceUomId` (default to "USD" if not provided)

2.  **Output:**
    *   `productId` of the newly created product.

3.  **Implementation:**
    *   Identify the relevant entities in Mantle USL to store product information (e.g., `Product`, `ProductPrice`).
    *   Write a service that creates new records in these entities using the provided input values.
    *   Ensure you handle the default value for `priceUomId`.

4.  **Dependencies:**
    *   Add any necessary dependencies in your custom component's `build.gradle` file to leverage Mantle business artifacts.

#### 2. Get Product Details Service (Part B)

1.  **Input Parameter:**
    *   `productId`

2.  **Output:** (Schema)
    *   `productId`
    *   `productName`
    *   `description`
    *   `price`
    *   `priceUomId`

3.  **Implementation:**
    *   Check if a product with the given `productId` exists.
    *   If not, throw an error message: "Product does not exist."
    *   If the product exists, retrieve and return the required details.
    *   **Consider using OOTB (out-of-the-box) services:** Moqui might already have built-in services for fetching product data. Explore the Mantle USL or Moqui core services to see if there's a suitable one you can leverage. 

### Run and Verify

*   **Run Services:** Execute both the create product and get product details services with sample input data.
*   **Verify Results:**
    *   Check that the product details are correctly created and retrieved.
    *   Verify the error handling for the get product details service when the `productId` doesn't exist.

### Assignment Submission

Push your new service implementations to the "moqui-training" repository.

**Additional Tips**

*   **Explore Mantle USL:** Take some time to familiarize yourself with the entities and services provided by Mantle USL.
*   **Documentation:** Refer to the Moqui documentation and Mantle documentation for detailed information about the available artifacts.
*   **Error Handling:** Implement proper error handling in your services to manage unexpected situations.

### Resources 

1. https://www.youtube.com/watch?v=lV0RqRtrnbU
