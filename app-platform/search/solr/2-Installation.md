To install Apache Solr, you just need to download and extract the package. The only system requirement is that you will need the **Java Runtime Environment (JRE) version 1.8 or higher**.

- Go to download page: https://solr.apache.org/downloads.html
- There are three packages:
  - "solr-8.11.x.tgz" for Linux/Unix/OSX systems
  - "solr-8.11.x.zip" for Microsoft Windows systems
  - "solr-8.11.x-src.tgz" the package Solr source code. This is useful if you want to develop on Solr without using the official Git repository.
- Download Version Solr 8.11.3
- Extract the file in desired directory


**After extracting the file test it -**
- Go to the directory where you extracted it
- Run this command to start a solr server-
```bash
bin/solr start
```
- This will start a solr server at port 8983
- You will see log like -
    `Started Solr server on port 8983 (pid=56856). Happy searching!`
- Now close the server using-
```bash
bin/solr stop -all
```

