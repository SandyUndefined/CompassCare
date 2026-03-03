part of 'appointments_bloc.dart';

sealed class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class AppointmentsRequested extends AppointmentsEvent {
  const AppointmentsRequested();
}

class AppointmentsRefreshed extends AppointmentsEvent {
  const AppointmentsRefreshed();
}

class AppointmentsAddRequested extends AppointmentsEvent {
  const AppointmentsAddRequested(this.input);

  final CreateAppointmentInput input;

  @override
  List<Object?> get props => [input];
}

class AppointmentRemoveRequested extends AppointmentsEvent {
  const AppointmentRemoveRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class AppointmentsNoticeCleared extends AppointmentsEvent {
  const AppointmentsNoticeCleared();
}
