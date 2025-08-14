import 'package:flutter/material.dart';
import 'package:proacademy_app/models/project_model';
import 'package:proacademy_app/models/user_model.dart';
import 'package:proacademy_app/services/project_service.dart';
import 'package:proacademy_app/services/user_service.dart';
import 'package:proacademy_app/services/user_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_project_view.dart';
import 'project_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserModel? _user;
  final List<ProjectModel> _projects = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await _loadUser();
    if (_user != null) {
      await _loadProjects();
    }
  }

  // ================== USER (Drawer) ==================
  Future<void> _loadUser() async {
    try {
      var user = await UserCache.load();
      if (user != null) {
        setState(() => _user = user);
      }

      final freshUser = await UserService.getMe();
      await UserCache.save(freshUser);
      setState(() => _user = freshUser);
    } catch (e) {
      setState(() => _error = 'Erro ao carregar dados do usuário: ${e.toString()}');
    }
  }

  Drawer _buildDrawer() {
    // --- PONTO DA MUDANÇA ---
    // Preparamos os textos de forma segura
    final email = _user?.email ?? '...';
    final course = _user?.course ?? '';
    final university = _user?.university ?? '';

    // Combinamos curso e universidade se existirem
    final List<String> secondaryInfo = [];
    if (course.isNotEmpty) secondaryInfo.add(course);
    if (university.isNotEmpty) secondaryInfo.add(university);
    
    // O texto final combina o email com as outras informações
    final accountEmailText = '$email\n${secondaryInfo.join(' - ')}';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            // Nome principal fica aqui
            accountName: Text(
              _user?.fullName ?? 'Carregando...',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Informações secundárias (email, curso, universidade) ficam aqui
            accountEmail: Text(
              accountEmailText,
              style: const TextStyle(height: 1.6), // Melhora o espaçamento entre linhas
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
            decoration: const BoxDecoration(color: Colors.deepPurple),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await UserCache.clear();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
            },
          ),
        ],
      ),
    );
  }

  // ================== PROJETOS ==================
  Future<void> _loadProjects() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final projectList = await ProjectService.fetchByUser();
      _projects
        ..clear()
        ..addAll(projectList);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onAddProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProjectView()),
    );

    if (result is Map && result['saved'] == true && result['dto'] is Map) {
      final dto = Map<String, dynamic>.from(result['dto'] as Map);
      await _createProject(dto);
    }
  }

  Future<void> _createProject(Map<String, dynamic> dto) async {
    try {
      final success = await ProjectService.createProject(dto);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Projeto criado com sucesso!')),
          );
        }
        await _loadProjects();
      } else {
        throw Exception('O servidor não confirmou a criação do projeto.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar projeto: $e')),
      );
    }
  }

  String _prazoRestante(DateTime? finishDate) {
    if (finishDate == null) return 'Sem prazo';
    final diff = finishDate.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Atrasado';
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    return '$diff dias restantes';
  }

  // ================== NAVEGAÇÃO ==================
  void _navigateToProjectDetail(ProjectModel project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailView(
          projectId: project.id,
          projectTitle: project.title,
        ),
      ),
    );
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProAcademy')),
      drawer: _buildDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Falha ao carregar:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _boot,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ))
              : RefreshIndicator(
                  onRefresh: _loadProjects,
                  child: _projects.isEmpty
                      ? const Center(child: Text("Nenhum projeto encontrado."))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _projects.length,
                          itemBuilder: (_, i) {
                            final p = _projects[i];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const Icon(Icons.folder_open),
                                title: Text(p.title),
                                subtitle: Text(
                                    'Prazo: ${_prazoRestante(p.finishDate as DateTime?)}'),
                                onTap: () => _navigateToProjectDetail(p),
                              ),
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddProject,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Projeto'),
      ),
    );
  }
}