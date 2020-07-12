# 1.0.2

* Update to Ruby 2.7.1
* Introduce Rubocop
* Added "Ruby" GitHub workflow

# 1.0.1

* Miscellaneous refactoring.

# 1.0.0

* Removed option for sample data report and verbose linear regression report.

# 0.3.2

* Internal refactoring

# 0.3.1

* Fixed bug

# 0.3.0

* The linear regression analysis report now produces a summary report of the
  regression for each sample. The sample data can by added by specifying the
  `--verbose` option.

# 0.2.0

* Adds quality control checks. Samples with values that are saturated,
  missing, or below a user-specified threshold are suppressed in the output.

# 0.1.1

* Bump the minimum required Ruby version to 2.4.4. On of our gem dependencies
  relies on this version.

# 0.1.0

* Initial version
