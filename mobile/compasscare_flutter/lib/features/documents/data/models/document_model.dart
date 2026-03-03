import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  const DocumentModel({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
  });

  final int id;
  final String name;
  final String date;
  final String type;

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
    );
  }

  factory DocumentModel.fromDbMap(Map<String, Object?> map) {
    return DocumentModel(
      id: map['id'] as int,
      name: map['name'] as String,
      date: map['date'] as String,
      type: map['type'] as String,
    );
  }

  Map<String, Object?> toDbMap() {
    return {'id': id, 'name': name, 'date': date, 'type': type};
  }

  @override
  List<Object?> get props => [id, name, date, type];
}
