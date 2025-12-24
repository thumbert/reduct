# reduct
A Dart package to generate code from a DuckDB table definition

## Description
The cycle to make an external data source available for local analysis is long 
and boring.  It often involves
 - writing code to download the data locally and ingest it into a database,
 - write code to pull that data from the database, often with various filters
 - create type safe objects for representing this query and the returned data
 - expose API endpoints to serve the data with all the filtering enabled 
 - prepare HTML documentation that explains the endpoints
 - often, client libraries are needed for different programming languages 

Since there are so many data sources one needs, it is best to automate and 
standardize these steps as much as possible.  My current setup that I've 
been using since early 2025 has been to have a Rust Actix server interacting 
with DuckDB databases.  

The information needed to complete most of the steps above is available once 
the DuckDB table definition is set in place.  So the goal of this package 
is to take that table definition and generate all the glue code to shortcut 
most of the other steps. 

