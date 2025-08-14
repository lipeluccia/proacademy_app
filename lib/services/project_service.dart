import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proacademy_app/core/constants/api_constants.dart';
import 'package:proacademy_app/models/project_model';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectService {
  static Future<List<ProjectModel>> fetchByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw StateError('Usuário não autenticado. Faça login novamente.');
    }

    final uri = Uri.parse('${ApiConstants.projectByUser}/$userId');
    final r = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 12));

    _log('GET $uri', r);

    if (r.statusCode == 204) return <ProjectModel>[];
    if (r.statusCode != 200) {
      throw StateError('Erro ao buscar projetos: ${r.statusCode}');
    }

    final decoded = jsonDecode(utf8.decode(r.bodyBytes)); // Suporte a acentos

    if (decoded is List) {
      return decoded
          .cast<Map<String, dynamic>>()
          .map(ProjectModel.fromJson)
          .toList();
    }

    throw StateError('Formato de resposta inesperado: ${r.body}');
  }

  static Future<bool> createProject(Map<String, dynamic> projectDto) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw StateError('Usuário não autenticado. Faça login novamente.');
    }

    final body = jsonEncode({
      'user': {'id': userId},
      'title': projectDto['title'],
      'description': projectDto['description'],
      'initialDate': projectDto['initialDate'],
      'finishDate': projectDto['finishDate'],
      'statusActive': true,
    });

    final uri = Uri.parse(ApiConstants.projectBase);
    final r = await http
        .post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    )
        .timeout(const Duration(seconds: 12));

    _log('POST $uri', r);

    return r.statusCode == 201 || r.statusCode == 200;
  }

  static void _log(String tag, http.Response r) {
    // ignore: avoid_print
    print('[ProjectService] $tag -> ${r.statusCode}');
  }
}