NotNaked is fashion brand for Gen Z and Gen Alpha in America. NotNaked is digital first company, has retail locations in following cities 

1) New York 
2) Boston
3) Chicago
4) Austin
5) New Orlieans 
6) Scotsdale AZ
7) Vegas 
8) Palo Alto
9) Portland OR


Retail locations for your fashion brand with products for Generation Z in outdoor shopping areas in the shortlisted cities:

* **New York:**
    * **Woodside Shopping Center:** 51-10 Broadway, Queens, NY 11377, USA. It has a 4.3 star rating on Google Maps.
    * **East Broadway Mall:** 88 E Broadway, New York, NY 10002, USA. It has a 3.7 star rating on Google Maps.
* **Boston:**
    * **Washington Park Mall:** 330 M.L.K. Jr Blvd, Boston, MA 02119, USA. It has a 4 star rating on Google Maps.
    * **South Bay Center:** 8 Allstate Rd, Boston, MA 02118, USA. It has a 4.3 star rating on Google Maps.
* **Chicago:**
    * **Water Tower Place:** 835 Michigan Ave, Chicago, IL 60611, USA. It has a 4.5 star rating on Google Maps.
    * **Riverside Square & River's Edge:** 3145 S Ashland Ave, Chicago, IL 21234, USA. It has a 4.3 star rating on Google Maps.
* **Austin:**
    * **The Domain:** 11410 Century Oaks Terrace, Austin, TX 78758, USA. It has a 4.5 star rating on Google Maps.
    * **Southpark Meadows:** 9500 S I-35 Frontage Rd, Austin, TX 78748, USA. It has a 4.4 star rating on Google Maps.
* **New Orleans:**
    * **Riverwalk Outlets:** 500 Port of New Orleans Pl, New Orleans, LA 70130, USA. It has a 4.4 star rating on Google Maps.
    * **Canal Place:** 333 Canal St, New Orleans, LA 70130, USA. It has a 4.4 star rating on Google Maps.
* **Scottsdale, AZ:**
    * **The Promenade Scottsdale:** 16243 N Scottsdale Rd, Scottsdale, AZ 85254, USA. It has a 4.5 star rating on Google Maps.
    * **Scottsdale Quarter:** 15279 N Scottsdale Rd Ste 260, Scottsdale, AZ 85254, USA. It has a 4.6 star rating on Google Maps.
* **Vegas:**
    * **Town Square Las Vegas:** 6605 S Las Vegas Blvd, Las Vegas, NV 89119, USA. It has a 4.6 star rating on Google Maps.
    * **Downtown Summerlin:** 1980 Festival Plaza Dr, Las Vegas, NV 89135, USA. It has a 4.6 star rating on Google Maps.
* **Palo Alto:**
    * **Gateway 101:** 1781 E Bayshore Rd, East Palo Alto, CA 94303, USA. It has a 4.2 star rating on Google Maps.
    * **Stanford Shopping Center:** 660 Stanford Shopping Center, Palo Alto, CA 94304, USA. It has a 4.5 star rating on Google Maps.
* **Portland, OR:**
    * **Hayden Meadows Square:** 1120 N Hayden Meadows Dr, Portland, OR 97217, USA. It has a 4 star rating on Google Maps.


NotNaked has warehouse at following locations 

**Memphis, Tennessee:**

```
123 Main Street
Memphis, TN 38103
```

**Indianapolis, Indiana:**

```
456 Elm Street
Indianapolis, IN 46204
```

**Columbus, Ohio:**

```
789 Oak Avenue
Columbus, OH 43215
```

**Savannah, Georgia:**

```
101 Pine Lane
Savannah, GA 31401
```


The tech stack of NotNaked is 
1) Shopify
2) HotWax Commmerce
3) NetSuite. 

NotNaked is organized to sell more and deliver fast, sell store inventory online and fulfill online orders from Store when it makes business sense. 

The NotNaked allows Omnichannel shopping experience where the, 

    * Customer places standard ship to home order
    * Customer places express ship to home order
    * Customer cancles Ship to home order within 10 mins of placing order (only if allowed on Shopify)
    * Customer returns 1 of many (e.g 3) ordered items on Shopify
    * Customer exchanges 1 of many (e.g 3) ordered items on Shopify








TODO:

Prepare list of scenarios 
    start with basics, the obvious ones, e.g Customer places BOPIS order,
    Order is received/imported in HC. 
        The Check if the facility assigned to the order is valid, The facility is configured to fulfill BOPIS order. Check if the orderItem has inventory reservation. Check if Order is listed in fulfillment application. 
        Thinking points: What configurations of HC enable BOPIS feature in OMS? FACT CHECKING
            Con you control 
                If config allows to choose Facility
                If config allows to choose Product for BOPIS from givin Facility
        You are testing the system configuration.
        
        How do we decide what to asset on?
        Starts with, What are we testing?
        In above example we are testing BOPIS configuration for a given client. We want to be sure that client system is configured to allow set of products for BOPIS order to be fulfilled from limited set of facilities/stores.


List reports available in Shopify.
Can any report in Shopify help reconciling data in Shopify with HC?
HotWax entities has set of Date fields, they are designed to be used for data sync between systems. Know about the attributes on entities and come up with posssible tests to validate integration processes

Testing returns
    Shopify Order facts should be checked with HC Order facts



