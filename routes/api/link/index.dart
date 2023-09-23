import 'dart:io' hide Link;

import 'package:dart_frog/dart_frog.dart';

import '../../../src/link.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      final queryParams = context.request.uri.queryParameters;
      if (queryParams.containsKey("short_code")) {
        return _retrieve(context, queryParams['short_code']!);
      }
      return _list(context);
    case HttpMethod.post:
      return _create(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _list(RequestContext context) async {
  final links = await Link.list();
  return Response.json(body: links);
}

Future<Response> _retrieve(RequestContext context, String shortCode) async {
  final link = await Link.retrieve(shortCode: shortCode);

  if (link != null) {
    return Response.json(body: link);
  }

  return Response.json(body: {'detail': 'Not Found'}, statusCode: 404);
}

Future<Response> _create(RequestContext context) async {
  final Map<String, dynamic> data = await context.request.json();

  if (!data.containsKey("url")) {
    return Response.json(body: {'detail': 'param `url` required'}, statusCode: 400);
  }

  String? customShortCode;

  if (data.containsKey("custom_short_code")) {
    final csc = data['custom_short_code'];
    if (Link.shortCodeIsValid(csc)) {
      customShortCode = csc;
    }
  }

  final link = await Link.create(data['url'], customShortCode: customShortCode);

  if (link == null) {
    return Response.json(body: {'detail': 'Something went wrong'}, statusCode: 500);
  }

  return Response.json(body: link);
}
