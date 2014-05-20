# lita-pivotal-tracker

Lita handler for adding Pivotal Tracker stories.

## Installation

Add lita-pivotal-tracker to your Lita instance's Gemfile:

``` ruby
gem "lita-pivotal-tracker"
```

## Configuration

config.handlers.pivotal_tracker.token = `YOUR_PIVOTAL_TRACKER_TOKEN`

## Usage

`pt add <arguments>`

### Arguments

* `[-p | --project PROJECT_NAME]` - The name of the Project
* `[-n | --name STORY_NAME]` - The Story's name
* `[-d | --description STORY_DESCRIPTION]` - The Story's description
* `[-e | --estimate STORY_ESTIMATE]` - Story estimate
* `[-t | --type STORY_TYPE]` - Story type. Defaults to 'feature'

### Examples

`lita pt add -p 'Death Star' -n 'Exhaust ports are ray shielded'` will add a Feature named "Exhaust ports are ray shielded" to the "Death Star" project.

`lita pt add -t bug -p 'Death Star' -n 'Explosive chain reaction in exhaust ports' -d 'Did we really design it like this?!?'` will add a Bug named "Explosive chain reaction in exhaust ports" with description "Did we really design it like this?!?" to the "Death Star" project.

## TODO
1. Story owner
2. Story requester
3. Story labels

## License

[MIT](http://opensource.org/licenses/MIT)
