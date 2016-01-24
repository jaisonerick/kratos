# Kratos

Kratos is a rails application generator based on
[Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

First install the kratos gem:

    gem install kratos

Then run:

    kratos projectname

This will create a Rails app in `projectname` using the latest version of Rails.

After run, configure sidekiq panel password in the
`config/initializers/sidekiq.rb` file. The panel is accessible by the URL
`/sidekiq`.

## License

Suspenders is Copyright © 2008-2015 thoughtbot.
It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE
