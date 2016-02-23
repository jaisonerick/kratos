# Kratos

Kratos is a rails application generator based on
[Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

First install the kratos gem:

    gem install kratos

Then run:

    kratos projectname

This will create a Rails app in `projectname` using the latest version of Rails.

After run, you must configure:

- Change the sidekiq panel password in the `config/initializers/sidekiq.rb`
  file.  The panel is accessible by the URL `/sidekiq`.
- Setup your development environment variables: `NEW_RELIC_LICENSE_KEY`,
  `ROLLBAR_TOKEN`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- Setup your production and staging environment variables using dotgpg. You must
  create two files on the root of your project: `env_production.gpg` and
  `env_staging.gpg`. To initialize dotgpg on your project run `dotgpg init`.
  It'll create a `.gpg` folder and add your public key to it. To edit the files,
  use the `dotgpg edit env_<environment>.gpg` command. For more information look
  at the [DotGPG](https://github.com/ConradIrwin/dotgpg).
- Run `bin/setup` to initialize your database and files.

## License

Suspenders is Copyright © 2008-2015 thoughtbot.
It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE
