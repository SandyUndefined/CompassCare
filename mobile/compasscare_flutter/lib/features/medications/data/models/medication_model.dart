import 'package:equatable/equatable.dart';

class MedicationModel extends Equatable {
  const MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.lastTaken,
    required this.nextDue,
    required this.critical,
  });

  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final String? lastTaken;
  final String? nextDue;
  final bool critical;

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      time: json['time'] as String,
      lastTaken: json['lastTaken'] as String?,
      nextDue: json['nextDue'] as String?,
      critical: json['critical'] as bool? ?? false,
    );
  }

  factory MedicationModel.fromDbMap(Map<String, Object?> map) {
    return MedicationModel(
      id: map['id'] as int,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      frequency: map['frequency'] as String,
      time: map['time'] as String,
      lastTaken: map['last_taken'] as String?,
      nextDue: map['next_due'] as String?,
      critical: (map['critical'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'lastTaken': lastTaken,
      'nextDue': nextDue,
      'critical': critical,
    };
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'last_taken': lastTaken,
      'next_due': nextDue,
      'critical': critical ? 1 : 0,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dosage,
    frequency,
    time,
    lastTaken,
    nextDue,
    critical,
  ];
}
