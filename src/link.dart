import 'dart:math';

import 'database.dart';
import 'utils.dart';

class Link {
  final int? id;
  final String originalUrl;
  final String shortCode;
  final DateTime createdAt;

  const Link({
    this.id,
    required this.originalUrl,
    required this.shortCode,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_url': originalUrl,
      'short_code': shortCode,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static String get tableName => "link";

  static String get insertSql => """
    INSERT INTO $tableName (original_url, short_code)
    VALUES (@originalUrl, @shortCode) RETURNING *;
    """;

  static Future<Link?> _insert(String originalUrl, String shortCode) async {
    try {
      final result = await db.query(insertSql, {
        'originalUrl': originalUrl,
        'shortCode': shortCode,
      });

      return _mapResponse(result).first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> _uniqueShortCode({String? customShortCode}) async {
    final shortCode = customShortCode ?? generateRandomString(10);
    final exists = await _retrieveByShortCode(shortCode) != null;

    if (exists || !shortCodeIsValid(shortCode)) {
      return await _uniqueShortCode();
    }

    return shortCode;
  }

  static Future<Link?> create(String originalUrl, {bool reuseUrl = true, String? customShortCode}) async {
    originalUrl = originalUrl.trim();

    if (reuseUrl) {
      final existing = await _retrieveByOriginalUrl(originalUrl);
      if (existing != null) {
        return existing;
      }
    }

    final shortCode = await _uniqueShortCode(customShortCode: customShortCode);

    return _insert(originalUrl, shortCode);
  }

  static Future<List<Link>> list() async {
    final response = await db.query("SELECT * FROM $tableName;");
    return _mapResponse(response);
  }

  static Future<Link?> retrieve({int? id, String? shortCode, String? originalUrl}) async {
    if (id != null) {
      return await _retrieveById(id);
    }

    if (shortCode != null) {
      return await _retrieveByShortCode(shortCode);
    }

    if (originalUrl != null) {
      return await _retrieveByOriginalUrl(originalUrl);
    }

    return null;
  }

  static Future<Link?> _retrieveByShortCode(String shortCode) async {
    try {
      final response = await db.query("SELECT * FROM $tableName WHERE short_code = @shortCode LIMIT 1;", {'shortCode': shortCode});
      if (response.isEmpty) {
        return null;
      }
      return _mapResponse(response).first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Link?> _retrieveById(int id) async {
    try {
      final response = await db.query("SELECT * FROM $tableName WHERE id = @id LIMIT 1;", {'id': id});
      if (response.isEmpty) {
        return null;
      }
      return _mapResponse(response).first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Link?> _retrieveByOriginalUrl(String originalUrl) async {
    try {
      final response = await db.query("SELECT * FROM $tableName WHERE original_url = @originalUrl LIMIT 1;", {'originalUrl': originalUrl});
      if (response.isEmpty) {
        return null;
      }
      return _mapResponse(response).first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<Link> _mapResponse(List<Map<String, Map<String, dynamic>>> response) {
    return response
        .map((result) => Link(
              id: result[tableName]!['id'],
              shortCode: result[tableName]!['short_code'],
              originalUrl: result[tableName]!['original_url'],
              createdAt: result[tableName]!['created_at'],
            ))
        .toList();
  }

  static bool shortCodeIsValid(String shortCode) {
    return shortCode.length >= 3 && shortCode.length <= 10 && !['api', 'link'].contains(shortCode.toLowerCase());
  }

  @override
  String toString() {
    return "[$id] $shortCode => $originalUrl";
  }
}
