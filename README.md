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

    if @signup.save
      redirect_to "/", notice: "You're signed up!"
    else
      render :new
    end
  end
end
```

If you want to report in all your controllers, include it in your
`ApplicationController` instead.

Also, keep in mind that since this is designed to help track user
form errors, HTTP GET requests are ignored.

The controller tracking will also attempt to inject the current user
if present.  By default, it will use a `current_user` method, only if
present.  If you wish to override this behavior, override the controller
method `validation_experience_user`

```ruby
def validation_experience_user
  current_member || current_admin
end
```

## Report data

Do whatever you want with your report data by assigning a handler to
`ValidationExperience.report`.  It receives `#call` with a hash of data
in the following format:

```ruby
{
  :referrer   => "http://www.example.com/foo?bar=buzz",
  :controller => "books",
  :action     => "create",
  :user       => {:id=>42, :type=>"User"},
  :models     => [
    {:id=>42, :name=>"Book", :errors=>[], :valid=>true},
    {:id=>nil, :name=>"Book", :errors=>[
      {:name=>"title", :message=>"can't be blank", :value=>nil}
    ], :valid=>false}
  ]
}
```

You can write this to ElasticSearch, send to Librato, KeenIO, Segment, or shove into PostgreSQL.  This part is up to you.

## Contributing

1. Fork it ( https://github.com/bemurphy/validation_experience/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
