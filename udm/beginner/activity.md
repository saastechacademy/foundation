https://confluence.hotwaxmedia.com/display/IMPL/Data+Model+Exercises


Setup up Company, Product store and Catalog:

Company and Product store data along with Catalog data need to setup by taking reference from OOTB DemoProduct.xml file.
These details are imaginary for a shoe store.

Activity - 1

Catalog:

Shoes Catalog

Categories:

    Browse Root
    – Men
    — MSports
    — MFormal
    — MParty
    – Women
    — WSports
    — WFormal
    — WParty
    – Children
    Promotion

Activity - 2 

Features:

Size

    – 7, 8, 9, 10, 11
Color

    – Red, Black, White, Brown

Products:

    – Virtual Products
    — Men > MSports
    ---- MS-1 with Color: White, Brown Size: 7, 8, 9, 10
    ---- MS-2 with Color: Red, Black Size: 7, 10
    — Men > MFormal
    ---- MF-1 with Color: Red, Black Size: 7, 10
    ---- MF-2 with Color: White, Brown Size: 7, 8, 9, 10
    — Men > MParty
    ---- MP-1 with Color: White, Brown Size: 7, 8, 9, 10
    ---- MP-2 with Color: Red, Black Size: 7, 8, 9, 10

    — Women > WSports
    ---- WS-1 with Color: White, Brown Size: 7, 8, 9
    ---- WS-2 with Color: Red, Black Size: 7, 8
    — Women > WFormal
    ---- WF-1 with Color: White, Brown Size: 7, 8, 9
    ---- WF-2 with Color: Red, Black Size: 7, 8, 9
    — Women > WParty
    ---- WP-1 with Color: White, Brown Size: 7, 8
    ---- WP-2 with Color: Red, Black Size: 7, 8

    – Children
    — C-1 with Color: White, Brown Size: 2, 3, 4, 5
    — C-2 with Color: Red, Black Size: 2, 3, 5

Activity - 3

– Promotion

    — MS-1 with Color: White, Brown Size: 7, 8, 9, 10
    — MF-2 with Color: White, Brown Size: 7, 8, 9, 10
    — MP-1 with Color: White, Brown Size: 7, 8, 9, 10
    — WS-1 with Color: White, Brown Size: 7, 8, 9
    — WF-1 with Color: White, Brown Size: 7, 8, 9
    — WP-1 with Color: White, Brown Size: 7, 8
    — C-1 with Color: White, Brown Size: 2, 3, 4, 5
    — C-2 with Color: Red, Black Size: 2, 3, 5


Party Data Model

Activity - 1

Do the following first from partymgr:

    Create a person by name Mark Tailor.
    Assign Customer role to created person.
    Change name of the person to Mark K Tailor.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.

Activity - 2

Do the following from webtools and see the effect of changes made on party profile page:

    Create a person by name John Liston.
    Assign Customer role to created person.
    Change name of the person to John D Liston.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.

Activity - 3

Do the following from party manager and then from webtools with observation from party profile page for effects of changes:

    Create a person by name John Hays.
    Assign Customer role to created person.
    Change name of the person to John B Hays.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Create credit cart for this customer.
    Add userlogin for the created party in the system.
    Assign a security group for accessing partymgr application to the created userLogin.
    Check access for created user login to partymgr application.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.



Activity - 4

Do the following from party manager and then from webtools with observation from party profile page for effects of changes:

    Create a person by name David Zeneski.
    Assign Customer role to created person.
    Change the name of the person to David R Zeneski.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Create credit cart for this customer.
    Add two userlogins for the created party in the system.
    Assign a security group for accessing ordermgr to first user and partymgr to second user.
    Check access for both userlogin to ordermgr and partymgr application.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.


Activity 1

    Order Id: HWMDEMO1000
    Order Status: Created
    Order Items: any two products from catalog.
    Order Items Status: Created
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - Visa 4111 1111 1111 1111
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

Activity 2

    Order Id: HWMDEMO1001
    Order Status: Approved
    Order Items: any two products from catalog.
    Order Items Status: Approved
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT,USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - Discover
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

Activity 3


    Order Id: HWMDEMO1001
    Order Status: Cancelled
    Order Items: any two products from catalog.
    Order Items Status: Cancelled
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: FEDEX Ground
    Billing Method: COD
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

Activity 4

    Order Id: HWMDEMO1001
    Order Status: Completed
    Order Items: any two products from catalog.
    Order Items Status: Completed
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    307 W 200 S
    Suite 4003
    Salt Lake City, UT
    Zip: 84101
    Phone: 888.405.2667
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - AMEX
    Billing Address:
    HotWax Media Inc.
    307 W 200 S
    Suite 4003
    Salt Lake City, UT
    Zip: 84101
    Phone: 888.405.2667

    OrderShipment:

    shipmentId: HwmDemo1000


