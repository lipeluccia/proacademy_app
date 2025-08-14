import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proacademy_app/core/constants/api_constants.dart';
import 'package:proacademy_app/views/auth/add_task_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProjectDetailView extends StatefulWidget {
  final int projectId;
  final String projectTitle;

  const ProjectDetailView({super.key, required this.projectId, required this.projectTitle});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  final List<Map<String, dynamic>> _tasks = [];
  bool _loading = true;
  String? _err;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() { _loading = true; _err = null; });
    try {
      final token = await _getToken();
      if (token == null) { setState(() { _loading = false; _err = 'Sem token'; }); return; }

      final resp = await http.get(
        Uri.parse('${ApiConstants.tasksByProject}/${widget.projectId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (resp.statusCode == 200) {
        final List list = json.decode(resp.body);
        setState(() {
          _tasks
            ..clear()
            ..addAll(list.cast<Map>().map<Map<String, dynamic>>((e) => {
                  'id': e['id'],
                  'title': e['title'] ?? '',
                  'description': e['description'] ?? '',
                }));
          _loading = false;
        });
      } else if (resp.statusCode == 204) {
        setState(() { _tasks.clear(); _loading = false; });
      } else {
        setState(() { _loading = false; _err = 'Erro ${resp.statusCode}'; });
      }
    } catch (_) {
      setState(() { _loading = false; _err = 'Falha de conexão'; });
    }
  }

  Future<bool> _createTaskEntity(Map<String, dynamic> jsonBody) async {
    try {
      final token = await _getToken();
      if (token == null) return false;
      final resp = await http.post(
        Uri.parse(ApiConstants.tasks),
        headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'},
        body: json.encode(jsonBody),
      );
      final ok = resp.statusCode == 201 || resp.statusCode == 200 || resp.statusCode == 204;
      if (ok) await _loadTasks();
      return ok;
    } catch (_) { return false; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.projectTitle)),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: Builder(
          builder: (_) {
            if (_loading) return const Center(child: CircularProgressIndicator());
            if (_err != null) return Center(child: Text('Erro: $_err', style: TextStyle(color: Colors.red)));
            if (_tasks.isEmpty) return const Center(child: Text('Sem tarefas', style: TextStyle(color: Colors.grey)));
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final t = _tasks[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(t['title'] ?? ''),
                    subtitle: Text(t['description'] ?? ''),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_task),
        label: const Text('Adicionar Tarefa'),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskView()));
          if (result is Map && result['saved'] == true) {
            final dto = Map<String, dynamic>.from(result['dto'] as Map);
            final ok = await _createTaskEntity({
              'project': {'id': widget.projectId},
              'title': dto['title'],
              'description': dto['description'],
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Tarefa adicionada!' : 'Erro ao salvar tarefa.')));
          }
        },
      ),
    );
  }
}
