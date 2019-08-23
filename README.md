# FlexStationData

Provides tools for reading and analyzing data from teh FlexStation microplate
reader.

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

### Viewing the sample data

To view the sample results from a set of plate readings, use the following
command:

    $ flex-station-data sample-data <source file> [--threshold=<threshold>]

Where `source file` is the file that you got from the reader. The `threshold`
setting is optional. If provided, samples with values that are below the
`threshold` value will be skipped. `threshold` must be a number.

The output is in CSV format. You'll probably want to save it to a file. You
can do that by piping the output to a file:

    $ flex-station-data sample-data source-data.csv --threshold=300 > sample-data.csv

### Performing linear regression analysis on the sample data

To perform a linear regression analysis on the sample data, use the following
command:

    $ flex-station-data liinear-regression <source file> [--threshold=<threshold>]

Note that the `source file` and `threshold` options are the same as for the
`sample-data` command above. The output is also similar, but includes the
slope and R² values for each sample. Again, you will probably want to pipe the
output to a file:

    $ flex-station-data sample-data source-data.csv --threshold=300 > linear-regression.csv

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johncarney/flex-station-data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlexStationData project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/johncarney/flex-station-data/blob/master/CODE_OF_CONDUCT.md).
