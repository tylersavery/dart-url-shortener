FROM dart:stable AS build

WORKDIR /app

RUN dart pub global activate dart_frog_cli
COPY . .
RUN dart pub get
RUN dart_frog build

RUN dart compile exe build/bin/server.dart -o build/bin/server


# CMD ["/app/build/bin/server"]