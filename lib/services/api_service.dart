import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proacademy_app/core/constants/api_constants.dart';
import 'package:proacademy_app/models/project_model';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<ProjectModel>> fetchProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.projectBase),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Erro ao carregar projetos: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<ProjectModel>> fetchProjectsByUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.projectByUser}/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Erro ao carregar projetos: ${response.statusCode} ${response.body}');
    }
  }
}
