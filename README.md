# Quetcd

[![Build Status](https://travis-ci.org/dpirotte/quetcd.svg?branch=master)](https://travis-ci.org/dpirotte/quetcd)

Quetcd is a simple message queue implemented on top of etcd. It is intended to handle high importance, low throughput messages.

This gem is very incomplete and not intended for production use.

## Usage

```ruby
require 'quetcd'

queue = Quetcd::Queue.new(url: "http://localhost:2379", name: "my_message_queue")

queue.enqueue("foo")

queue.dequeue
# => "foo"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpirotte/quetcd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

