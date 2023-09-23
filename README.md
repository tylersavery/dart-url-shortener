# Dart URL Shortener

A simple URL shortener written in dart.

### Prerequisits
* Dart
* Docker

### Getting Started

#### Activate dart_frog_cli
```
dart pub global activate dart_frog_cli
```

#### Run Docker Compose (for PG)
```
docker-compose up -d
```

#### Config
```
touch .env
```
Put in these details:
```
DATABASE_URL=postgres://postgres:postgres@localhost:5432/postgres
DATABASE_NO_SSL=true
FALLBACK_URL=https://google.com
```


#### SQL

Link table:
```
CREATE TABLE link (
    id SERIAL PRIMARY KEY,
    original_url TEXT NOT NULL,
    short_code VARCHAR(10) UNIQUE NOT NULL,
    user_identifier VARCHAR(64),
    created_at TIMESTAMP DEFAULT NOW()
);
```

Click table
```
CREATE TABLE click (
    id SERIAL PRIMARY KEY,
    link_id INT REFERENCES link(id),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    user_ip VARCHAR(15) NOT NULL
);
```

### Running
```
dart_frog dev
```

### API Endpoints

`GET /api`
Returns the status `{"online": "true"}`

`GET /link`
Returns all links in the database

`GET /link?short_code=SHORT_CODE`
Returns a serialized link or a 404

`POST /link` 
Post Params: `{'url':'URL_TO_SHORTEN'}`
Creates a new link and returns the serialized link



### Depoying
You can follow the [dart_frog docs](https://dartfrog.vgv.dev/docs/category/deploy) to deploy. 

For Heroku, follow these steps:
* Create Heroku app
* Add the Heroku Postgres addon
* Run:
```
heroku git:remote -a {{YOUR APP NAME}}
heroku stack:set container --app {{YOUR APP NAME}}
heroku config:set FALLBACK_URL={{YOUR FALLBACK URL}}
git add .
git commit -m"commit message"
git push heroku main
```

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)


[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis