TODO:
 - Implement required filters, that is filters without which the URL is invalid. Give example!
 - Fix all tests!
 - For a Rust Zoned field, add the annotation to serialize and deserialize 
   the field to skip the explicit timezone  

# 2026-05-25
 - The Dart toUriParams() method of the QueryFilter class the fields have 
   unneeded parentheses, for example:  parms['hub'] = (hub).toString();  
 - Don't crash when there are comment lines in sql

# 2026-05-15
- Allow BOOL as column type, not only BOOLEAN

# 2026-04-17
- Fix bug introduced on 4/16

# 2026-04-16 (0.3.5)
- Introduce onlyFilter argument to generate API query parameters for only a subset of 
  columns.

# 2026-04-09
- Fix path of the Dart client url (it had an extra /)

# 2026-04-08
- Provide clear error when timezoneName is not specified for a TIMESTAMPTZ column

# 0.3.4 (2026-03-06)
- Add equality and hashCode methods to the Dart Record class.
- Make the Dart client Record class toJson() method output consistent with fromJson()
  and the Rust implementation.   

# 0.3.3 (2026-03-03)
- Fix imports in Rust API file. 

# 0.3.2 (2026-02-18)
- Minor fix on the snake case extension when dealing with digits.

# 0.3.1 (2026-02-11)
- Minor fix on the snake case extension.  

# 0.3.0 (2026-01-19)
- Support TIME column type.  First cut.

# 0.2.1 (2026-01-12)
- Fix the toSnakeCase() implementation to convert 'ARA1' -> 'ARA_1'

# 0.2.0 (2026-01-07)
- Add an optional limit field for SQL all queries.
- Dart client improvements
    - Add Dart client test file.
    - Add an optional `limit` argument to the `queryRecords` function to 
      limit the number or records returned.
    - Add `toUriParams` method to the `QueryFilter` class.
    - Add `toString` method to the `QueryFilter` class.  
    - Improved generated docs.
- Rust client improvements: 
    - Generate the API test using the `QueryFilterBuilder` and `_limit` parameter. 
    - Add impl method `to_query_url` to go from a `QueryFilter` to an url
    - Serialize Optional<Decimal> columns as float (default is String)
- Html documentation improvements:
    - Add the `_limit` parameter and document it's use.    

## 0.1.3 (2026-01-04)
- Improvements to both the Rust and Dart clients. 

## 0.1.2 (2026-01-01)
- Started work the Dart code generation.  Progress on enums. 

## 0.1.1 (2025-12-30)
- Improvements to the Rust API.

## 0.1.0 (2025-12-29)
- Initial version.  Rust components are mostly working. 
