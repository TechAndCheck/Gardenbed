# Gardenbed

Gardenbed is a *very* early work-in-progress attempt at TUI (text user interface) framework for Ruby apps that
run in the console.

Why would this be useful? Couldn't you use just run individual scripts in multiple windows or use [TMUX](https://github.com/tmux/tmux/wiki)?
Well, yes, for simple apps that don't need to really interact with each other. However, say you want to set up
a dashboard, but you also don't want the overhead or security issues that come with running a full web
service to display everything? Say, for instance, something is scraping while also monitoring objects
being found and you just want to keep that available? Well, this could do that, probably, eventually.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gardenbed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gardenbed

## Usage

VERY TBD at the moment

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Before making commits be sure to run `git config commit.template .gitmessage` to set the commit message template on your local machine. Any commits not using this format will receive a very stern warning from @cguess.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gardenbed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gardenbed project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gardenbed/blob/master/CODE_OF_CONDUCT.md).

## Contact
Created by Christopher Guess (@cguess)
Sponsored by the [Duke Reporters' Lab](https://www.reporterslab.org)
