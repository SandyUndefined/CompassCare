import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';

class BundledCareData {
  const BundledCareData._();

  static const List<MedicationModel> medications = [
    MedicationModel(
      id: 1,
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      time: '8:00 AM',
      lastTaken: '8:05 AM - Sarah',
      nextDue: '8:00 AM tomorrow',
      critical: true,
    ),
    MedicationModel(
      id: 2,
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      time: '8:00 AM, 8:00 PM',
      lastTaken: '8:10 AM - Michael',
      nextDue: '8:00 PM today',
      critical: false,
    ),
    MedicationModel(
      id: 3,
      name: 'Aspirin',
      dosage: '81mg',
      frequency: 'Once daily',
      time: '9:00 AM',
      lastTaken: '9:02 AM - Linda',
      nextDue: '9:00 AM tomorrow',
      critical: false,
    ),
  ];

  static const List<AppointmentModel> appointments = [
    AppointmentModel(
      id: 1,
      type: 'Cardiology',
      doctor: 'Dr. Johnson',
      date: 'Feb 10, 2026',
      time: '2:30 PM',
      location: 'Memorial Hospital',
      assignedTo: 'Sarah',
      notes: 'Bring recent blood pressure log',
    ),
    AppointmentModel(
      id: 2,
      type: 'Primary Care',
      doctor: 'Dr. Smith',
      date: 'Feb 15, 2026',
      time: '10:00 AM',
      location: 'Family Health Center',
      assignedTo: 'Michael',
      notes: 'Annual checkup',
    ),
    AppointmentModel(
      id: 3,
      type: 'Ophthalmology',
      doctor: 'Dr. Lee',
      date: 'Feb 22, 2026',
      time: '1:00 PM',
      location: 'Vision Care Clinic',
      assignedTo: 'Linda',
      notes: 'Diabetic eye exam - dilating drops will be used',
    ),
  ];

  static const List<CareTeamMemberModel> careTeamMembers = [
    CareTeamMemberModel(
      id: 1,
      name: 'Sarah',
      role: 'Daughter',
      online: true,
      lastActive: 'Just now',
    ),
    CareTeamMemberModel(
      id: 2,
      name: 'Michael',
      role: 'Son',
      online: true,
      lastActive: '5 min ago',
    ),
    CareTeamMemberModel(
      id: 3,
      name: 'Linda',
      role: 'Spouse',
      online: false,
      lastActive: '2 hours ago',
    ),
  ];

  static const List<DocumentModel> documents = [
    DocumentModel(
      id: 1,
      name: 'Insurance Card',
      date: 'Updated Jan 15, 2026',
      type: 'PDF',
    ),
    DocumentModel(
      id: 2,
      name: 'Blood Pressure Log',
      date: 'Updated Feb 5, 2026',
      type: 'PDF',
    ),
    DocumentModel(
      id: 3,
      name: 'Lab Results - Dec 2025',
      date: 'Dec 20, 2025',
      type: 'PDF',
    ),
    DocumentModel(
      id: 4,
      name: 'Medication List',
      date: 'Updated Feb 1, 2026',
      type: 'PDF',
    ),
    DocumentModel(
      id: 5,
      name: 'Advance Directive',
      date: 'Mar 10, 2025',
      type: 'PDF',
    ),
  ];
}
