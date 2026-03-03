import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.type,
    required this.doctor,
    required this.date,
    required this.time,
    required this.location,
    required this.assignedTo,
    required this.notes,
  });

  final int id;
  final String type;
  final String doctor;
  final String date;
  final String time;
  final String location;
  final String assignedTo;
  final String? notes;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int,
      type: json['type'] as String,
      doctor: json['doctor'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String? ?? '',
      assignedTo: json['assignedTo'] as String? ?? '',
      notes: json['notes'] as String?,
    );
  }

  factory AppointmentModel.fromDbMap(Map<String, Object?> map) {
    return AppointmentModel(
      id: map['id'] as int,
      type: map['type'] as String,
      doctor: map['doctor'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      assignedTo: map['assigned_to'] as String,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'doctor': doctor,
      'date': date,
      'time': time,
      'location': location,
      'assignedTo': assignedTo,
      'notes': notes,
    };
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'type': type,
      'doctor': doctor,
      'date': date,
      'time': time,
      'location': location,
      'assigned_to': assignedTo,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    type,
    doctor,
    date,
    time,
    location,
    assignedTo,
    notes,
  ];
}
