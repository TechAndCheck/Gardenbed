# Gardenbed

Gardenbed is a *very* early work-in-progress attempt at TUI (text user interface) framework for Ruby apps that
run in the console.

Why would this be useful? Couldn't you use just run individual scripts in multiple windows or use [TMUX](https://github.com/tmux/tmux/wiki)?
Well, yes, for simple apps that don't need to really interact with each other. However, say you want to set up
a dashboard, but you also don't want the overhead or security issues that come with running a full web
service to display everything? Say, for instance, something is scraping while also monitoring objects
being found and you just want to keep that available? Well, this could do that, probably, eventually.

This project is heavily influenced by [Ruby on Rails](https://www.rubyonrails.com), but sometimes you have to copy from the best.

## Infrastructure

This is (currently) made up of two parts:
1. A skeleton app
1. A gem of the same name

## Requirements

Unsure, aside from my 2015 Macbook Pro running MacOS 10.15.1

It probably works out of the box on Linux, but you may need to install ncurses

## Installation

This is supposed to contain your whole application, everything will eventually run in within itself.

What this means is some basic set up is necessary (eventually this will all be automated with generators ala Rails)

### Prerequisites
#### Mac:
**Note:** This has only been installed on MacOS 10.15.1, but it'll probably work on any POSIX system that can link against `ncurses`
1. Make sure you have [Homebrew](https://brew.sh/), the package manager for MacOS (think Apt or Yum).
   If you don't, follow the instructions on the home page of the project to install
1. Install `ncurses` by doing the following `brew install ncurses`
1. Make sure you have Ruby 2.7.1 installed (2.6 probably works fine, but it's non-tested). I usually do this with [rvm](https://rvm.io/)

#### Linux:
Probably the same as Mac except with your distro's flavor of installing `ncurses`.

### For now
1. Clone this repo `git clone https://github.com/techandcheck/gardenbed`
1. Copy `app.rb.demo` and rename it to `app.rb`
1. Run `bundle install`
1. Start it up! `ruby bin/start`

## Usage

Start it up with `ruby bin/start`.

Mostly take a look at `app.rb` for the moment, but we'll get there!

There's not much you can do with it now except show basic stuff, but just wait, we'll get there.

## Development

Before making commits be sure to run `git config commit.template .gitmessage` to set the commit message template on your local machine. Any commits not using this format will receive a very stern warning from @cguess.

Debugging is tricky, since normal Ruby debuggers expect you to just drop into them. However, we take up the full screen, so that's not really possible.
Instead what we can do is use Byebug's remote debugging. To make it easy we can use [tmux](https://github.com/tmux/tmux/wiki) to split the screen and
automatically set everything up so any bugs are caught in the remote session instead of breaking the app itself.

To run this `bash bin/dev`

For those curious this does the following:
1. Start up tmux and name the session `gardenbed`
1. Run the `ruby bin/start` script
1. While that's booting, split the window into two panes
1. Run `bash bin/debugger` which loops trying to start the remote debugger until it can connect (the server can take some time)
1. Attaches to the debugger

If you're not familiar with tmux this might be confusing, but there's a good tutorial on the project's page linked above.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/techandcheck/gardenbed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gardenbed project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/techandcheck/gardenbed/blob/master/CODE_OF_CONDUCT.md).

## Contact
Created and maintained by Christopher Guess (@cguess)
Sponsored by the [Duke Reporters' Lab](https://www.reporterslab.org)
