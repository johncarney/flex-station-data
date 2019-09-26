# FlexStationData

Tools for reading and analyzing data from the FlexStation microplate reader.

Currently this is somewhere between alpha and beta.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flex-station-data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flex-station-data

## Updating

To update your installation, use:

    $ gem update flex-station-data

## Usage

To perform a linear regression analysis on the sample data, use the following
command:

    $ flex-station linear-regression <source file> [--threshold=<threshold>] [--min-r-squared=<minimum R²>]

Where `source file` is the file that you got from the reader. You can specify
multiple source files. The `threshold` setting is optional. If provided,
samples with values that are below the `threshold` value will be skipped.
`threshold` must be a number.

If a `--min-r-squared` value is given, samples with a R² value that falls
below the threshold will be flagged as "poor fits." If no `--min-r-squared` is
specified, a default of 0.75 will be used.

The output is in CSV format. You'll probably want to save it to a file. You
can do that by piping the output to a file:

    $ flex-station linear-regression source-data.csv --threshold=300 > linear-regression.csv

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/johncarney/flex-station-data. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlexStationData project’s codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/johncarney/flex-station-data/blob/master/CODE_OF_CONDUCT.md).
