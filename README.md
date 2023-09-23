# Dart URL Shortener

A simple URL shortener written in dart.

### Prerequisits
* Dart
* Docker

### Getting Started

```
dart pub global activate dart_frog_cli
docker-compose up -d
```

### Env
```
touch .env
```
Put in these details:
```
DATABASE_URL=postgres://postgres:postgres@localhost:5432/postgres
DATABASE_NO_SSL=true
FALLBACK_URL=https://google.com
```

### Running
```
dart_frog dev
```

### SQL

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

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

An example application built with dart_frog

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis