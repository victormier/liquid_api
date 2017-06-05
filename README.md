# MVP2 API

### Getting started

```bash
rake db:create
rake db:migrate
```

### Running the server

```bash
bundle exec rackup -p 3000
```

### Running the console (like `rails console` for rack)

```bash
racksh
```

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
