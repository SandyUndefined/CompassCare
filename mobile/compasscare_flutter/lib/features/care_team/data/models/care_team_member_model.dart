import 'package:equatable/equatable.dart';

class CareTeamMemberModel extends Equatable {
  const CareTeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.online,
    required this.lastActive,
  });

  final int id;
  final String name;
  final String role;
  final bool online;
  final String? lastActive;

  factory CareTeamMemberModel.fromJson(Map<String, dynamic> json) {
    return CareTeamMemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String,
      online: json['online'] as bool? ?? false,
      lastActive: json['lastActive'] as String?,
    );
  }

  factory CareTeamMemberModel.fromDbMap(Map<String, Object?> map) {
    return CareTeamMemberModel(
      id: map['id'] as int,
      name: map['name'] as String,
      role: map['role'] as String,
      online: (map['online'] as int? ?? 0) == 1,
      lastActive: map['last_active'] as String?,
    );
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'online': online ? 1 : 0,
      'last_active': lastActive,
    };
  }

  @override
  List<Object?> get props => [id, name, role, online, lastActive];
}
