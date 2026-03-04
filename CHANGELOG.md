TODO:
 - Implement required filters, that is filters without which the URL is invalid.
 - Fix all tests!

# 0.3.3 (2026-03-03)
- Fix imports in Rust API file 

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
