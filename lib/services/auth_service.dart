import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:proacademy_app/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'user_cache.dart';
import 'user_service.dart'; // Importe o UserService

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    try {
      final r = await http
          .post(
            Uri.parse(ApiConstants.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 12));

      _log('login', r);

      if (r.statusCode != 200) {
        throw StateError('Credenciais inválidas (${r.statusCode})');
      }

      final data = jsonDecode(r.body) as Map<String, dynamic>;
      final token = (data['token'] as String?) ?? '';
      if (token.isEmpty) throw StateError('Token ausente na resposta da API.');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // --- PONTO DA MUDANÇA ---
      // Agora usa o UserService para buscar os dados do usuário
      final user = await UserService.getMe();
      // ------------------------

      await prefs.setInt('userId', user.id);
      await UserCache.save(user); // Salva no cache para o Drawer usar

      return user;

    } on SocketException {
      throw StateError('Servidor inacessível. Verifique sua conexão.');
    } on TimeoutException {
      throw StateError('Tempo de resposta esgotado. Tente novamente.');
    }
  }

  void _log(String tag, http.Response r) {
    final preview = r.body.isEmpty ? '<vazio>' : (r.body.length > 400 ? '${r.body.substring(0, 400)}...' : r.body);
    // ignore: avoid_print
    print('[AuthService] $tag -> ${r.statusCode}\n$preview');
  }
}