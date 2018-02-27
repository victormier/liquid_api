# Liquid API

### Running the container

The first time you have to set up a couple things. This will take a while:

```bash
docker-compose up
docker-compose run web bundle exec rake db:reset
```

Afterwards you just have to type the following to start the server:

```bash
docker-compose up
```

For running commands inside the container:

```bash
docker-compose run web {COMMAND}
```

Recomendation: set up a couple aliases for saving up typing time:

```bash
alias docker-rake=docker-compose run web bundle exec rake
alias docker-spec=docker-compose run web bundle exec rspec
```

### Running the console

Like `rails console` for rack

```bash
docker-compose run web racksh
```

### Debugging emails

Emails in development are delivered to mailcatcher. Mailcatcher runs as an independent service in the docker-compose system.

Mailcatcher will catch all emails which can be viewed in `http://localhost:1080/`.


### Generating migrations

We use the [active_record_migrations](https://github.com/rosenfeld/active_record_migrations) gem for rails-like active record migrations.

```
docker-compose run web rake "db:new_migration[CreateUser, name birth:date]"
```

### Debugging with pry

[Check this guide](https://gist.github.com/briankung/ebfb567d149209d2d308576a6a34e5d8)


# Features
* Graphql API
* TOKEN AUTH

### DB
* Postgresql (with ActiveRecord)
