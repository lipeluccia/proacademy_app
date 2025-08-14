import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proacademy_app/core/constants/api_constants.dart';
import 'package:proacademy_app/models/user_create_dto.dart';
import 'package:proacademy_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  /// Cadastra um novo usuário na API.
  static Future<bool> cadastrarUsuario(UserCreateDTO user) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// Busca os dados do usuário logado (/user/me).
  static Future<UserModel> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw StateError('Token não encontrado. Faça login novamente.');
    }

    final uri = Uri.parse(ApiConstants.me);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Usando utf8.decode para garantir o parse correto de acentos
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonMap = jsonDecode(decodedBody) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } else {
      throw StateError('Falha ao obter dados do usuário: ${response.statusCode}');
    }
  }
}