### What is a Product?
A product is an individual piece of merchandise or service that can be offered in the market to satisfies customer's needs. A product can be manufactured from the raw material or simply processed to be sold as finished good which is branded, packages and labeled by the company. A products are distinguished based on the unique Id/SKUs and are available with various features such as color, style, size, brands etc.

#### Product Variant Association
**Virtual & Variant Product** 
In eCommerce a virtual product is modeled to group products with similar features into a product having undefined feature (Size & Color etc). These products allow user to provide specific information about the product to select a real product (X Color, Y size).

A virtual product is a product which has several selectable features, each of which resolves to an actual physical product. Each of the selectable feature combination will result into a variant with standard features.

For eg: A T-shirt is a virtual product which is available in different sizes (small, medium large and extra large) and colors (red, grey, blue, green and black). So Color and Size are the selectable features of Virtual product T-shirt which does not exist physically in the inventory. Now if I select Small size and Red color then actually there will be a variant T-shirt in with these two features as standard features.

**Product Association**
A Product Variant association is used to associate Virtual Product with its Variants. You can associate as many variant with a virtual product as feature combinations possible but only single unit of a variant will be associated with a virtual product.

For this association virtual product must be setup as a finished good and have isVirtual set to 'Y' indicating that no inventory is kept for this product. Similarly the variant product must also be set as a finished good and have isVariant set to 'Y'. The virtual product product will have some selectable features associated with them that will be indeed associated as standard features with one or more variants.

Purpose: The main purpose of this association is to group the similar products with similar features set to be sold as a single product on the online store. This association is also used by a merchandiser to organize products in the catalog sharing similar attributes at but sold at one place as a separate merchandise unit.

Sample Data Setup
Prerequisite Data:

 Click here to view Prerequisite Data
Product Variant Association
	Variant Product Association

```
<ProductAssoc fromDate="2001-05-13 12:00:00.0" productAssocTypeId="PRODUCT_VARIANT" productId="T-Shirt" productIdTo="SS-SR" quantity="1.0" reason=""/>
<ProductAssoc fromDate="2001-05-13 12:00:00.0" productAssocTypeId="PRODUCT_VARIANT" productId="T-Shirt" productIdTo="SS-SB" quantity="1.0" reason=""/>
```

### Product Component Association
Package, Bundle, Kit and Components
Product packages, bundles and kits are collection or grouping of products which allows merchandiser to sell multiple products as a single unit. This facilitates the customer to buy a multiple related products on one click. Components are the products which are collected together to be sold as bundle or kit or a package.

Bundles are collection of similar items allowing merchandiser to offer several units of a products for sale as one combined product. These are usually sold at low marginal cost therefore incites customer to purchase products in bulk. The components in the bundle can also be sold separately depending on the merchandising policies.

Kits or Packages are collection of related items that are intended for same purpose or use. A merchandiser groups multiple related products to be sold in a kit or package that sometimes may not be sold independently. Kits or packages can be pre-built or customizable depending on the merchandising requirement.

For example: A burger may be $10, but it's combo package offering fries and a drink for $5 more. If purchased separately, the fries and drink would cost $5 each.

**Product Association**
Product Component association is used to associate a component with its package/bundle. You can associate as many components as possible with a package/bundle and any number of component units can be added to them.

For this association the package/bundle should already be setup as Marketing Package. The component products will be setup as normal finished goods. When a package or bundle is purchased then the price applicable to that package or bundle is offered to the customer and the component level price is ignored. For individual component sale the component level pricing will be applicable.

Purpose: The main purpose of this association is to allow merchandiser to sell related products collectively as a single unit at low marginal price. Merchandiser uses this association for promotional purpose and to increase sales of some related products that can be ignored if sold individually. With this merchandiser can allow customers to purchase multiple related products on single click and at low marginal prices.

Sample Data Setup
Prerequisite Data:

Product Component Association:

```
  <ProductAssoc productId="Compaq_260S" productIdTo="Compaq_Monitor" productAssocTypeId="PRODUCT_COMPONENT" quantity="1" fromDate="2007-01-01 12:00:00.0"/>
  <ProductAssoc productId="Compaq_260S" productIdTo="Compaq_Keyboard" productAssocTypeId="PRODUCT_COMPONENT" quantity="1" fromDate="2007-01-01 12:00:00.0"/>
  <ProductAssoc productId="Compaq_260S" productIdTo="Compaq_CPU" productAssocTypeId="PRODUCT_COMPONENT" quantity="1" fromDate="2007-01-01 12:00:00.0"/>
  <ProductAssoc productId="Compaq_260S" productIdTo="Compaq_Speaker" productAssocTypeId="PRODUCT_COMPONENT" quantity="2" fromDate="2007-01-01 12:00:00.0"/>
```

### Upgrade (Up-Sell) Product Association
Upgrade or Up-sell Products
Product upgrades or Up-sell items are more advanced and expensive products or service which are offered by a merchandiser to the customer who is interested in buying another product.The upgrade products may have better quality, brand and of-course better feature which customer might be interested in buying by just a little more investments.

The advantage of Up-sell products is that customers are often happier with the more advanced & expensive product while merchandiser earned more profitability from them.

For example: A merchandiser can offer a larger size LED television screen to the customers buying regular television screen. Or offer combo of Set-top box attached with the television set.

Product Association
Product Upgrade association is used to associate a product with its up-sell items that belong to the same category (may belong to different sub-categories).

For this association you should have products already setup as Finished Goods, which can be a standard, virtual or package product. A product can have any number of upgrade products associated with it. In case of large number of upgrade products they should have sequenced in the order to be displayed if merchandiser want to give priority to the products viewed by the customer at first glance.

Purpose:  This association allows merchandiser to display the upgrade products listed on the Product detail page with another product. With this there are more chances that customer will be attracted to buy more expensive product from the store instead of the product he/she was originally buying.

Sample Data Setup
Prerequisite Data:

 Click here to view Prerequisite Data
Product Upgrade Association:

```	
<ProductAssoc fromDate="2010-07-16 18:07:41.64" productAssocTypeId="PRODUCT_UPGRADE" productId="9000" productIdTo="9004" sequenceNum="1"/>
<ProductAssoc fromDate="2010-07-16 18:06:59.267" productAssocTypeId="PRODUCT_UPGRADE" productId="9000" productIdTo="9005" sequenceNum="2"/>
```

### Complementary (Cross-Sell) Product Association
Complementary(Cross-sell) Product
A Complementary or Cross-sell product is the one suggested to the buyer in addition to the current product that is being purchased. It might be in the same category as the current product or a completely different category. Cross sell has no relevancy with the price of the current product but are related in terms of being Sold together because of being Used together. Merchandiser offers cross-sell products and services ensuring that the additional product or service being sold to the client enhances the value of the products being purchased

It gives customer an idea of what else they can purchase that might be useful to them along with the product originally purchased.

For example: While purchasing a Cell phone, merchandiser can recommend related accessories like a hands-free kit and extended charge battery etc.

Product Association
Complementary Product association allows a merchandiser to associate related additional products which can be bought by the customer in addition to the items he/she is currently buying.

For this association you should already have the products setup as Finished Goods, which can be a standard, virtual or package product. A product can have any number of upgrade products associated with it. In case of large number of upgrade products they should have sequenced in the order to be displayed if merchandiser want to give priority to the products viewed by the customer at first glance.

Purpose: This association is used to motivate customer to buy more products from the store that are related in the sense of being used together. This association also allows merchandiser to display the cross-sell/complementary products listed on the Product detail page of another product or as soon as they add any product to the cart.

Sample Data Setup
Prerequisite Data:

 Click here to view Prerequisite Data
Product Complement Association:

```	
<ProductAssoc productAssocTypeId="PRODUCT_COMPLEMENT" productId="9000" productIdTo="9004" sequenceNum="1" fromDate="2010-07-16 18:07:41.64"/>
<ProductAssoc productAssocTypeId="PRODUCT_COMPLEMENT" productId="9000" productIdTo="9005" sequenceNum="2" fromDate="2010-07-16 18:06:59.267"/>
```

### Recommended (Also Bought) Product Association
Recommended (Also Bought) Products
Recommended products are used to influence customer to buy more products based on the tendency to buy the products that other customer have also bought. These product might belong to same category or from completely different category. By showing products as "Who bought this also bought" merchandiser provides customer an opportunity to suggest the products that customer might also like to purchase based on his/her current choice of the product.

These products are quite similar to Cross-sell and Up-sell products but recommended products are not necessarily related based on price, feature or dependent usability. It can be any product which merchandiser wants the customer to know without having customer specifically browse that product.

Product Association
Also Bought product association allow merchandiser to associated products that he/she would like to recommend to the customer with the current product being browsed or purchased. You can associate any number of products as Also-Bought or recommendation.

For association products in this association type you should have all the products already setup in the database. For more number of recommended products, ordering should be provided so that products with higher preference would be displayed to the customer at first glance without scrolling.

Purpose: This association is basically used by merchandiser to advertise or introduce customer with other products on the site without having customer browse that category/product by them selves.

Sample Data Setup
Prerequisite Data:

 Click here to view Prerequisite Data
Also Bought Association:

```	
<ProductAssoc productAssocTypeId="ALSO_BOUGHT" productId="9000" productIdTo="9004" fromDate="2010-07-16 18:06:59.267"/>
<ProductAssoc productAssocTypeId="ALSO_BOUGHT" productId="9000" productIdTo="9005" fromDate="2010-07-16 18:07:41.64"/>
```
