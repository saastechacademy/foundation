## Glossary:

When navigating Solr's terminology, it's common to encounter confusion between certain terms. Let's discuss each one to ensure clarity.

### 1. Cluster:

A cluster refers to a group of interconnected Solr nodes working together. It contains all the nodes in the environment, collaborating to provide a scalable and fault-tolerant search solution. Nodes within a cluster communicate with each other to distribute data, handle queries, and maintain system stability.

### 2. Solr Node:

Solr nodes are individual instances of the Solr server running on separate machines within a SolrCloud cluster. Each Solr node manages one or more collections of indexed data and handles search requests from clients. Solr nodes communicate with each other and with ZooKeeper for cluster coordination, ensuring that the search index remains consistent across the cluster.

### 3. Collection:

Collections in SolrCloud are logical groupings of cores managed together as a single unit. They enable scalability and distributed search capabilities by organizing related data as a single entity. Collections span multiple Solr nodes and partition data across multiple cores for efficient processing.

### 4. Shard:

Refers to a subset of a larger index. When an index becomes too large to handle on a single server, it is divided into smaller, more manageable pieces called shards. Each shard contains a portion of the index's data and can be stored on a separate server or node within a SolrCloud cluster. Sharding helps improve performance, scalability, and fault tolerance by distributing the index across multiple servers, allowing for parallel processing of queries and better resource utilization.

### 5. Replica:

A replica is a copy of a shard that runs on a separate Solr node within the cluster. Replicas are used to provide fault tolerance and high availability by ensuring that data is replicated across multiple nodes. If a node hosting a shard replica goes down, queries can still be served by other replicas of the same shard.

### 6. Cores:

A core in Solr is a fundamental unit representing a complete physical index on a Solr node. It handles indexing and searching operations for a specific set of data, containing configuration files, index data, and other necessary resources. Cores are used to separate documents with different schemas or belonging to different collections, and each core operates independently with its own configuration, schema, and set of indexed documents.

### 7. Config Set:

A configuration set in Solr defines the schema structure, indexing settings, and other configurations used by cores within a collection. It includes details such as field definitions, analysis chains, update request handlers, and more. Config sets provide a way to manage and share common configurations across multiple cores or collections within a SolrCloud cluster.

### 8. ZooKeeper: 

ZooKeeper is a centralized service for maintaining configuration information, providing distributed synchronization, and managing cluster state for distributed systems like SolrCloud. In a SolrCloud deployment, ZooKeeper manages cluster coordination tasks such as leader election, shard allocation, and tracking the status of individual Solr nodes. It stores metadata about collections, shards, and replicas, enabling Solr nodes to dynamically join or leave the cluster without affecting its availability or data integrity.




