# WsIntegration
Gem helps with integrating Rails application with Worksnaps.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ws_integration', git: 'https://github.com/krzysztofgrzybowski/ws_integration'
```

And then execute:
```bash
$ bundle
```

To create initializer file and migration run:
```bash
$ rails generate ws_integration User
```
As a parameter add your user class name using camel case. 'User' is set as default.

Generator creates initializer file inside /config/initializers/ws_integration.rb
```ruby
Rails.configuration.x.user_class_name = 'User'
Rails.configuration.x.worksnaps_token = 'YOUR_WORKSNAPS_TOKEN'
```
Put you Worksnaps token here. Remember to keep it safe!
After changing class name use generator again to create new migration.

## Usage
Gem adds few functions inside your user class:

To synchronize all your users:
```ruby
User.synchronize_with_worksnaps
```

To get single user data from Worksnaps:
```ruby
get_worksnaps_data
```

To add Worksnaps time for user:
```ruby
add_worksnaps_time(project_id, task_id, from_timestamp, minutes, comment)
```

## Contributing
Contact me: krzysztof.grzybowski@polcode.net

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
