import 'package:dart_frog/dart_frog.dart';

import '../src/config.dart';
import '../src/database.dart';
import '../src/link.dart';

Future<Response> onRequest(RequestContext context, String shortCode) async {
  final link = await Link.retrieve(shortCode: shortCode);

  String userIp =
      context.request.headers['x-forwarded-for'] ?? context.request.headers['x-real-ip'] ?? context.request.connectionInfo.remoteAddress.address;

  if (userIp.contains(":")) {
    userIp = userIp.split(":").last;
  }

  if (userIp.contains(',')) {
    userIp = userIp.split(',').first;
  }

  if (userIp.length > 15) {
    userIp = '';
  }

  if (link != null) {
    await db.query(
      "INSERT INTO click (link_id, user_ip) VALUES (@linkId, @userIp);",
      {
        'linkId': link.id,
        'userIp': userIp.trim(),
      },
    );

    return Response(headers: {'Location': link.originalUrl}, statusCode: 302);
  }

  return Response(headers: {'Location': Config().fallbackUrl}, statusCode: 302);
}
