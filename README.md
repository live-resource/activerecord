# LiveResource::ActiveRecord

This gem provides the ActiveRecord LiveResource dependency.

## Installation

Add this line to your application's Gemfile:

    gem 'live_resource-activerecord'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install live_resource-activerecord

## Configuration

You need to add this to the list of supported dependency types in your application config.

```ruby
# config/application.rb (or development.rb, test.rb etc)

class Application < Rails::Application
  ...
  config.live_resource = {
        dependency_types: [LiveResource::ActiveRecord::Dependency]
  }
end
```

## Usage

```ruby
# app/controllers/profiles_controller.rb

class ProfilesController < ApplicationController
  ...

  # show.json
  # {
  #   name: @profile.name,
  #   avatar: {
  #     alt_text: @profile.avatar.alt_text,
  #     url: avatar_url( @profile.avatar )
  #   }
  # }
  def show
    ...
  end

  live_resource :show do
    identifier { |profile| profile_path(profile) }

    # When a Profile instance is changed
    depends_on(Profile) do |profile|
      # Push an update for the resource belonging to the profile
      push(profile)
    end

    # Since the view will change if the avatar changes, depend on that too
    depends_on(Avatar) do |avatar|
      push avatar.profile
    end
  end

  ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
