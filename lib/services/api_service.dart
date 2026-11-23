import 'dart:convert';
import 'package:http/http.dart' as http;

/// ═══════════════════════════════════════════════════════════════════
///  👉 POUR TESTER SUR TÉLÉPHONE PHYSIQUE (même Wi-Fi que le PC) :
///     Remplacez "localhost" par l'IP LAN de votre PC, ex :
///     http://192.168.1.42/api-test/public
///     (trouvez-la avec `ipconfig` → IPv4 Address)
///
///  👉 POUR L'ÉMULATEUR ANDROID : utilisez http://10.0.2.2/api-test/public
/// ═══════════════════════════════════════════════════════════════════
const String kApiBaseUrl = 'http://localhost/api-test/public';

class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  ApiException(this.message, [this.errors]);
  @override
  String toString() => message;
}

class ApiService {
  // ─── AUTH ───────────────────────────────────────────────────────────

  /// Retourne les infos du compte (id, email, created_at) si succès,
  /// lève une ApiException sinon.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$kApiBaseUrl/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = _decode(res);
    if (res.statusCode == 200 && body['success'] == true) {
      return Map<String, dynamic>.from(body['data']);
    }
    throw ApiException(
      body['message']?.toString() ?? 'Identifiants incorrects',
    );
  }

  // ─── MEMBRES ────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> listMembers() async {
    final res = await http.get(Uri.parse('$kApiBaseUrl/famille-membres'));
    final body = _decode(res);
    if (res.statusCode == 200 && body['success'] == true) {
      final list = body['data'] as List;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    throw ApiException(body['message']?.toString() ?? 'Erreur de chargement');
  }

  /// Crée un membre. `imagePath` est facultatif (chemin local du fichier).
  /// Retourne le membre créé (avec image_url éventuel).
  static Future<Map<String, dynamic>> createMember({
    required Map<String, String> fields,
    String? imagePath,
  }) async {
    final uri = Uri.parse('$kApiBaseUrl/famille-membres');
    final res = imagePath == null
        ? await http.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(fields),
          )
        : await _multipart('POST', uri, fields, imagePath);
    return _checkMember(res, expected: 201);
  }

  /// Met à jour un membre sans changer l'image (PUT JSON).
  static Future<Map<String, dynamic>> updateMember({
    required int id,
    required Map<String, String> fields,
  }) async {
    final res = await http.put(
      Uri.parse('$kApiBaseUrl/famille-membres/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fields),
    );
    return _checkMember(res);
  }

  /// Met à jour un membre AVEC une nouvelle image (POST form-data).
  static Future<Map<String, dynamic>> updateMemberWithImage({
    required int id,
    required Map<String, String> fields,
    required String imagePath,
  }) async {
    final res = await _multipart(
      'POST',
      Uri.parse('$kApiBaseUrl/famille-membres/$id'),
      fields,
      imagePath,
    );
    return _checkMember(res);
  }

  static Future<void> deleteMember(int id) async {
    final res =
        await http.delete(Uri.parse('$kApiBaseUrl/famille-membres/$id'));
    final body = _decode(res);
    if (res.statusCode != 200 || body['success'] != true) {
      throw ApiException(body['message']?.toString() ?? 'Erreur suppression');
    }
  }

  // ─── HELPERS ────────────────────────────────────────────────────────

  static Map<String, dynamic> _decode(http.Response res) {
    try {
      return Map<String, dynamic>.from(jsonDecode(res.body));
    } catch (_) {
      throw ApiException('Réponse invalide du serveur (${res.statusCode})');
    }
  }

  static Map<String, dynamic> _checkMember(
    http.Response res, {
    int expected = 200,
  }) {
    final body = _decode(res);
    if (res.statusCode == expected && body['success'] == true) {
      return Map<String, dynamic>.from(body['data']);
    }
    throw ApiException(
      body['message']?.toString() ?? 'Erreur serveur',
      body['errors'] != null
          ? Map<String, dynamic>.from(body['errors'])
          : null,
    );
  }

  static Future<http.Response> _multipart(
    String method,
    Uri uri,
    Map<String, String> fields,
    String imagePath,
  ) async {
    final req = http.MultipartRequest(method, uri);
    req.fields.addAll(fields);
    req.files.add(await http.MultipartFile.fromPath('image', imagePath));
    final streamed = await req.send();
    return http.Response.fromStream(streamed);
  }
}