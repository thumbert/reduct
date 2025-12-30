# reduct
A Dart package to generate polyglot code from a DuckDB table definition

## Description

The steps to make an external data source available for local analysis are 
long and boring.  It is best to automate and standardize these steps as 
much as possible.  The setup that this package is supporting consists of a 
Rust Actix server interacting with DuckDB databases.  Client libraries from 
multiple programming languages are made available to interact and parse the 
result of the server in a type safe manner.  The goal is to have client 
support for Rust and Dart.  Contributions by the community to clients in 
other languages are welcome. 

All the information needed to complete most of the steps is available once 
the DuckDB table definition is set in place.  So the goal of this package 
is to take that table definition and generate all the glue code needed. 

This involves
 - writing code to download the data locally and ingest it into a database
 - write code to pull data from the database, with various filters
 - create type safe objects for representing this query and the returned data
 - generate API endpoint in Actix to serve the data with all the filtering enabled
     - create a type safe object for parsing the URL into the query structure   
 - prepare HTML documentation that explains the endpoint
 - generate client libraries for different programming languages. 

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

### DuckDB

For the sake of consistency, the table definition in DuckDB the column names 
should be in **snake_case**.  If not, an error will will thrown. 

### Rust (server + client)

#### Rust Server 
The generated code for the Rust enums respect the Rust naming conventions 
for the enum and variants (**camelCase**) while at the same time ensuring that the 
serialization returns back the original values as stored in the database. 

#### Rust Client

### Dart (client only)

The Dart client will generate objects to represent a record in the database and 
a function to retrieve the data according to the various filters supported. 

