# Apache Solr
- Apache SOlr is a scalable, ready to deploy, search/storage engine optimized to search large volumes of text-centric data
- It is open source, used to build search applications

## Features
- Restful APIs
- Full text search
- Enterprise ready (can deploy in any system)
- Flexible and extensible (customisable components)
- NoSQL database
- Admin interface (manage logs, add, delete, update and search documents)
- Highly scalable
- Near Real-Time Indexing
- Faceted Search
- Geospatial Search
- Highlighting
- Spell Checking
- Analytics and Reporting
- Security
- Integration with Other Systems
- Community and Ecosystem

Apache Solr is a feature-rich and versatile search engine that provides powerful search and indexing capabilities for a wide range of applications and use cases. Its comprehensive set of features, scalability, flexibility, and robustness make it a popular choice for organizations seeking to implement advanced search functionality in their applications. Whether it's e-commerce websites, enterprise search solutions, or data analytics platforms, Solr offers the tools and capabilities needed to deliver fast, accurate, and relevant search experiences to users.



![image](https://github.com/coder-1304/Apache-Solr-doc/assets/121802518/8f645f64-d13a-420c-973a-7c16e8fef990)


Solr makes it easy to add the capability to search through the online store through the following steps:
1. Define a schema
   - Content of documents it will be indexing
   - In online store example, the schema would define fields for the product name, description, price, manufacturer, and so on
2. Feed solr documents for which users will search
3. Expose search functionality in your application

Solr queries are simple HTTP request URLs and the response is a structured document.

For better scalability, you can include SolrCloud to better distribute the data and the processing of requests across many servers.

For example- `Sharding` is a scaling technique in which a collection is split into multiple logical pieces called "Shards" in order to scale up the number of documents in a collection beyond what could physically fit on a single server.

Incoming queries are distributed to every shard in the collection, which respond with merged results

"Replication Factor" allows you to add servers with add servers with additional copies of your collection to handle higher concurrent query load by spreading the quests around to multiple machines.

Sharding and replication are not mutually exclusive, and together make solr an extremely powerful and scalable platform 
