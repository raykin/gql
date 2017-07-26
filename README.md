# Gql

Class-Method way to serve grahql server in ruby.

In Development!

## Difference from graphql-ruby

Class-Method style coding compare to block code in graphql-ruby

Use obvious convention to code less and bug less. But only obvious convention was used to reduce surprise.

## Examples

In {hero {name age}}

the ruby server code can be

```ruby
class QueryType < Gql::ObjectType
  def hero
    User.new
  end
end

class Hero
  attr_accessor :name, :age
  def initialize(name='foo', age='unknown')
    @name, @age = name, age
  end
end

```

The result will be

```ruby
  {data: {hero: {name: 'foo', age: 'unknown'}}}
```

## Installation (Not released yet, do not try following)

Add this line to your application's Gemfile:

```ruby
gem 'gql-not-released-yet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gql-not-released-yet

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/raykin/gql.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
