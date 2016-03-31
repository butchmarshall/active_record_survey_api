[![Gem Version](https://badge.fury.io/rb/active_record_survey_api.svg)](http://badge.fury.io/rb/active_record_survey_api)
[![Build Status](https://travis-ci.org/butchmarshall/active_record_survey_api.svg?branch=master)](https://travis-ci.org/butchmarshall/active_record_survey_api)

# ActiveRecordSurvey

API implementation for [ActiveRecordSurvey](https://github.com/butchmarshall/active_record_survey)

Release Notes
============

**0.0.11**
 - Now supports direct question -> question relationships

**0.0.10**
 - Can now pass sibling-index attribute when updating answer resources

**0.0.9**
 - Compatability fixes for ActiveRecordSurvey 0.1.30

**0.0.7**
 - Endpoints for getting/setting/removing an answers next question

**0.0.4**
 - Basic survey building and taking

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_survey_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_record_survey_api

## Sample frontend

    $ cd spec/test_app
    $ bundle exec rake db:migrate
    $ passenger start

Navigate to localhost:3000 - you'll get a frontend GUI implemented in [angularjs](https://github.com/angular/angular.js)

## Usage

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/butchmarshall/active_record_survey_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

