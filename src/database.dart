import 'package:postgres/postgres.dart';

import 'config.dart';

class Database {
  Database();

  Future<List<Map<String, Map<String, dynamic>>>> query(
    String q, [
    Map<String, dynamic> substitutionValues = const {},
  ]) async {
    final connection = await connect();
    final data = await connection.mappedResultsQuery(q, substitutionValues: substitutionValues);
    await connection.close();
    return data;
  }

  Future<PostgreSQLConnection> connect() async {
    final (username, password, host, port, databaseName) = _dbUrlToComponents(Config().databaseUrl);

    final connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
      useSSL: !Config().databaseNoSsl,
    );
    await connection.open();

    return connection;
  }

  (String, String, String, int, String) _dbUrlToComponents(String dbUrl) {
    final uri = Uri.parse(dbUrl);
    final username = uri.userInfo.split(":")[0];
    final password = uri.userInfo.split(":")[1];
    final host = uri.host;
    final port = uri.port;
    final databaseName = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : "";

    return (username, password, host, port, databaseName);
  }
}

final db = Database();
