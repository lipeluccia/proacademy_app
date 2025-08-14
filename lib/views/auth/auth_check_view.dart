import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckView extends StatefulWidget {
  const AuthCheckView({super.key});

  @override
  State<AuthCheckView> createState() => _AuthCheckViewState();
}

class _AuthCheckViewState extends State<AuthCheckView> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Adiciona um pequeno delay para a splash screen ser visível
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Se tem token, vai para a home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Senão, vai para a tela de boas-vindas
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Carregando...'),
          ],
        ),
      ),
    );
  }
}