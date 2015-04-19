# ValidationExperience

ValidationExperience is a gem for Rails that tracks model validation failures and
reports on them.

This helps you see if your forms are confusing to your users by monitoring what
fields they tend to fail on the most.

## Installation

Add this line to your application's Gemfile:

    gem 'validation_experience'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validation_experience

## Usage

Setup an initializer in `config/initializers/validation_experience`:

```ruby
# Opt in all models.  If you don't want all models tracked,
# you can explicitly include the mixin in the models you want
ActiveRecord::Base.include ValidationExperience::Model

# Inject the recording backend, by default it just logs
# The report just needs to be something that responds to
# `call` and accepts a hash of data
ValidationExperience.report = Proc.new {|data| puts data}

```

Then in your controllers you want to report on:

```ruby
class SignupController < ApplicationController
  include ValidationExperience::Controller

  # This calls `around_action`.  It will accept options
  # like `:exclude` and `:only` and pass them on to `around_action`
  track_validation_experience

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)

    if signup.save
      redirect_to "/", notice: "You're signed up!"
    else
      render :new
    end
  end
end
```

If you want to report in all your controllers, include it in your
`ApplicationController` instead.

## Report data

Do whatever you want with your report data via `ValidationExperience.report`.
It receives a hash of data in the following format:

```ruby
{
  :referrer   => "http://www.example.com/foo?bar=buzz",
  :controller => "books",
  :action     => "create",
  :models     => [
    {:id=>book1.id, :name=>"Book", :errors=>[], :valid=>true},
    {:id=>nil, :name=>"Book", :errors=>[{:name=>"publishing_year", :message=>"can't be blank", :value=>nil}], :valid=>false}
  ]
}
```

You can write this to ElasticSearch, send to Librarto, KeenIO, Segment, or shove into PostgreSQL.  This part is up to you.

## Contributing

1. Fork it ( https://github.com/bemurphy/validation_experience/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
