part of 'appointments_bloc.dart';

enum AppointmentsStatus { initial, loading, success, failure }

enum AppointmentsNoticeType { success, error }

class AppointmentsNotice extends Equatable {
  const AppointmentsNotice({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final AppointmentsNoticeType type;

  @override
  List<Object?> get props => [id, message, type];
}

class AppointmentsState extends Equatable {
  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const [],
    this.isRefreshing = false,
    this.isFromCache = false,
    this.isAddingAppointment = false,
    this.removingAppointmentIds = const [],
    this.notice,
  });

  final AppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final bool isRefreshing;
  final bool isFromCache;
  final bool isAddingAppointment;
  final List<int> removingAppointmentIds;
  final AppointmentsNotice? notice;

  bool get isInitialLoading =>
      status == AppointmentsStatus.loading && appointments.isEmpty;

  bool isRemovingAppointment(int id) => removingAppointmentIds.contains(id);

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    bool? isRefreshing,
    bool? isFromCache,
    bool? isAddingAppointment,
    List<int>? removingAppointmentIds,
    AppointmentsNotice? notice,
    bool clearNotice = false,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      isAddingAppointment: isAddingAppointment ?? this.isAddingAppointment,
      removingAppointmentIds:
          removingAppointmentIds ?? this.removingAppointmentIds,
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [
    status,
    appointments,
    isRefreshing,
    isFromCache,
    isAddingAppointment,
    removingAppointmentIds,
    notice,
  ];
}
