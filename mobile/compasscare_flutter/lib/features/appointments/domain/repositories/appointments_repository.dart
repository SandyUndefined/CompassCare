import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:equatable/equatable.dart';

enum AppointmentDataOrigin { network, cache }

class AppointmentFetchResult extends Equatable {
  const AppointmentFetchResult({
    required this.appointments,
    required this.origin,
  });

  final List<AppointmentModel> appointments;
  final AppointmentDataOrigin origin;

  @override
  List<Object?> get props => [appointments, origin];
}

class CreateAppointmentInput extends Equatable {
  const CreateAppointmentInput({
    required this.type,
    required this.doctor,
    required this.date,
    this.time = '',
    this.location = '',
    this.assignedTo = '',
    this.notes,
  });

  final String type;
  final String doctor;
  final String date;
  final String time;
  final String location;
  final String assignedTo;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'doctor': doctor,
      'date': date,
      'time': time,
      'location': location,
      'assignedTo': assignedTo,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    type,
    doctor,
    date,
    time,
    location,
    assignedTo,
    notes,
  ];
}

abstract class AppointmentsRepository {
  Future<AppointmentFetchResult> fetchAppointments();
  Future<AppointmentModel> addAppointment(CreateAppointmentInput input);
  Future<void> removeAppointment(int id);
}
