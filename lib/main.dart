import 'package:flutter/material.dart';
import 'package:proacademy_app/views/auth/add_project_view.dart';
import 'package:proacademy_app/views/auth/auth_check_view.dart';
import 'package:proacademy_app/views/auth/home_view.dart';
import 'package:proacademy_app/views/auth/login_view.dart';
import 'package:proacademy_app/views/auth/register_view.dart';
import 'package:proacademy_app/views/auth/welcome_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProAcademy',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      // A rota inicial agora é a tela de verificação
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheckView(),
        '/welcome': (context) => const WelcomeView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/add_project': (context) => const AddProjectView(),
      },
    );
  }
}