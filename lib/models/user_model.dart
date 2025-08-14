class UserModel {
  final int id;
  final String fullName;
  final String email;
  final DateTime? birthday;
  final String course;
  final String university;
  final DateTime? creationDate;
  final Set<int>? profiles;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.birthday,
    required this.course,
    required this.university,
    this.creationDate,
    this.profiles,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null; // agora só retorna null
    if (v is String) {
      final d = DateTime.tryParse(v);
      if (d != null) return d;
    }
    if (v is List && v.length >= 3) {
      return DateTime((v[0] as num).toInt(), (v[1] as num).toInt(), (v[2] as num).toInt());
    }
    if (v is Map && v.containsKey('year')) {
      return DateTime(
        (v['year'] as num).toInt(),
        (v['month'] as num).toInt(),
        (v['day'] as num).toInt(),
      );
    }
    return null;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      birthday: _parseDate(json['birthday']),
      course: (json['course'] ?? '').toString(),
      university: (json['university'] ?? '').toString(),
      creationDate: _parseDate(json['creationDate']),
      profiles: json['profiles'] != null
          ? Set<int>.from((json['profiles'] as List).map((e) => (e as num).toInt()))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'birthday': birthday?.toIso8601String(),
        'course': course,
        'university': university,
        'creationDate': creationDate?.toIso8601String(),
        'profiles': profiles?.toList(),
      };
}
