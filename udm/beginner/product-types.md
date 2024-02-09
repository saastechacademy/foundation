# Product Types:-

This classification system outlines the fundamental traits and features common to a set of products. Each product is assigned a single product category and product type. Multiple products can be associated with a single product type, indicating a many-to-one relationship.
  
**Finished goods**  are goods that have completed the manufacturing process but have not yet been sold or distributed to the end user. Eg-- Cars, Computers, Spare parts etc.

**Raw Material** is the basic material used for manufacturing of a product/good. It is in unprocessed or minimal processed state.

**Services** are the intangible products such as accounting, banking, cleaning, consultancy, education, insurance, expertise, medical treatment, or transportation. The services are rendered to us by service providers having expertise in the particular field. No transfer of possession or ownership takes place when services are sold, and they cannot be stored or transported, and they come into existence at the time they are bought and consumed.

**Good** -- A good is a tangible physical product which we sell to our customers that can be contrasted with a service which is intangible. As such, it is capable of being delivered to a purchaser and involves the transfer of ownership from seller to customer. For example, an apple is a tangible good, as opposed to a haircut, which is an (intangible) service.

**Configurable Good** – When there are large number of parts which go in a product or whose combination constitute a product, then such kind of product is known as a configurable good. Ex-- Bike, Computer, Cell phone etc.

**Work In Process** is a product which has not been completed during the manufacturing process. 

**Digital goods** is a general term that is used to describe any goods that are stored, delivered and used in its electronic format. Digital goods may also be called electronic goods or e-goods. Digital goods are shipped electronically to the consumer through e-mail or download from the Internet. Usually when you purchase digital goods online, after payment has been received the merchant will provide you with your digital item as an e-mail attachment or they may provide you with a secure link where you can download the item. Examples of digital goods include e-books, music files, software, digital images, Web site templates, manuals in electronic format, and any item which can be electronically stored in a file or multiple files.

**Virtual product** is a product which has no real inventory associated with it.

**Variant product** -- A product variant is a specific item that is grouped with related variants that together form a product. Variants usually vary from each other in one or more properties. For example, a medium-sized, green shirt is one product variant of the Shirt product; together size and color form one variant. Group of features for a particular product at an instance is termed as product variant. Before you can add a product variant to a product, you must specify in the product definition that the product will include variants. A virtual product does not hold physical inventory, as it represents non-tangible items, while a variant product may or may not have physical inventory associated with it.

**Marketing Package** -- It involves purchasing of any product or products in the form of a combo or package. It can be auto manufactured and offered by company, like Barbie Set---Doll, Comb, Dress, Accessories etc, or it can be picked manually by the customer from a given group of items. It is designed as per the need of the customer for the purpose of best pick. 

### Relationships
The relationships for the "product type" entity can be further detailed as follows:

- **Product Type to Product:** This relationship defines the various types of products available in the system. For example, a "Finished Good" product type is a type for the goods that have completed manufacturing process but not sold.
- **Product Type to ChildProductType:** This relationship defines the hierarchy of product types. For instance, "Digital Good" and 
"Finished Good" can be a child product type of "GOOD" product type.
- **Product Type to ProductTypeAttr:** This relationship involves the attributes associated with each product type.

## Activity

**The Table** Name the table for managing master list of product types.
**The Relationships** Name related tables.

### Activity Answers

- Master list of product types: ProductType
- Relationships Name: ChildProductType, Product, ProductTypeAttr
