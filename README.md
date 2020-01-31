# NHLGem

Scrapes today's schedule from NHL.com and returns the number of games for the day, and those being currently played (in addition to their scores).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'NHLGem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install NHLGem

## Usage

This gem currently only has one function:

#### NHLGamesGem#check_games
Will return one of three strings:
  - No games scheduled for today
  - Games scheduled, those currently in progress will have their score returned
  - Games scheduled, all are finished

Example (currently scheduled):
```
There are 3 games today, and there are currently 3 games in progress:
   
   Montréal Canadiens are currently leading Buffalo Sabres 3-1.
   Nashville Predators are currently leading New Jersey Devils 6-5.
   Los Angeles Kings are currently leading Arizona Coyotes 3-2.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schlaBAM/NHLGamesGem This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NHLGem project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/NHLGem/blob/master/CODE_OF_CONDUCT.md).
