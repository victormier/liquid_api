# Liquid API

### Getting started

```bash
rake db:create
rake db:migrate
```

### Running the server

```bash
bundle exec rackup -p 3000
```

### Running the console

Like `rails console` for rack

```bash
racksh
```

### Debugging emails

Emails in development are delivered to mailcatcher. Mailcatcher should be install as an independent gem:

```bash
gem install mailcatcher
mailcatcher
```

Mailcatcher will catch all emails which can be viewed in `http://localhost:1080/`. Just run `mailcatcher` in a console to start the mail server as a daemon.


### Generating migrations

We use the [active_record_migrations](https://github.com/rosenfeld/active_record_migrations) gem for rails-like active record migrations.

```
rake "db:new_migration[CreateUser, name birth:date]"
```



# Features
* Graphql API
* CSRF and SESSION
* TOKEN AUTH

### DB
* Postgresql (with ActiveRecord)
