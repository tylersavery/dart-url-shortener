import 'package:dotenv/dotenv.dart';

class Config {
  Config() {
    init();
  }

  late final DotEnv environment;

  void init() {
    environment = DotEnv(includePlatformEnvironment: true)..load();
  }

  String get databaseUrl {
    return environment['DATABASE_URL'] ?? '';
  }

  bool get databaseNoSsl {
    return environment['DATABASE_NO_SSL'] == "true";
  }

  String get fallbackUrl {
    return environment['FALLBACK_URL'] ?? 'https://google.com/';
  }
}
