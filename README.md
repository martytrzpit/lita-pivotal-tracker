# lita-pivotal-tracker

[![Build Status](https://travis-ci.org/martytrzpit/lita-pivotal-tracker.png?branch=master)](https://travis-ci.org/martytrzpit/lita-pivotal-tracker)
[![Code Climate](https://codeclimate.com/github/martytrzpit/lita-pivotal-tracker.png)](https://codeclimate.com/github/martytrzpit/lita-pivotal-tracker)
[![Coverage Status](https://coveralls.io/repos/martytrzpit/lita-pivotal-tracker/badge.png)](https://coveralls.io/r/martytrzpit/lita-pivotal-tracker)

**lita-pivotal-tracker** is a handler plugin for [Lita](https://www.lita.io/) that manages [Pivotal Tracker](https://www.pivotaltracker.com/) stories.

## Installation

Add lita-pivotal-tracker to your Lita instance's Gemfile:

``` ruby
gem "lita-pivotal-tracker"
```

## Configuration

config.handlers.pivotal_tracker.token = `YOUR_PIVOTAL_TRACKER_TOKEN`

## Usage

`(pt|pivotaltracker) add [feature (default) | bug | chore] <name> to <project>`

### Examples

`lita pt add Exhaust ports are ray shielded to Death Star` will add a __Feature__ named _Exhaust ports are ray shielded_ to the _Death Star_ project.

`lita pt add bug Explosive chain reaction in exhaust ports to Death Star` will add a __Bug__ named _Explosive chain reaction in exhaust ports_ to the _Death Star_ project.

## License

[MIT](http://opensource.org/licenses/MIT)
