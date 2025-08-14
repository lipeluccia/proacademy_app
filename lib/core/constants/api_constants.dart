class ApiConstants {
  static const String baseUrl = 'http://10.0.0.155:8090';

  // Auth (com /api)
  static const String login    = '$baseUrl/api/auth/login';
  static const String register = '$baseUrl/api/auth/register';

  // Users (SEM /api)
  static const String me = '$baseUrl/user/me';

  // Projects (SEM /api)
  static const String projectBase     = '$baseUrl/project';
  static const String projectByUser   = '$baseUrl/project/user';   // + '/{userId}'

  // Tasks (SEM /api)
  static const String tasks           = '$baseUrl/task';
  static const String tasksByProject  = '$baseUrl/task/project';   // + '/{projectId}'
}
