import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';
import 'package:compasscare_flutter/features/medications/presentation/bloc/medications_bloc.dart';
import 'package:compasscare_flutter/features/medications/presentation/widgets/medication_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MedicationsBloc(repository: context.read<MedicationsRepository>())
            ..add(const MedicationsRequested()),
      child: const _MedicationsView(),
    );
  }
}

class _MedicationsView extends StatelessWidget {
  const _MedicationsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicationsBloc, MedicationsState>(
      listenWhen: (previous, current) =>
          previous.notice?.id != current.notice?.id && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) {
          return;
        }

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(notice.message),
            backgroundColor: notice.type == MedicationsNoticeType.error
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        );
        context.read<MedicationsBloc>().add(const MedicationsNoticeCleared());
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Medication Schedule',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: state.isAddingMedication
                        ? null
                        : () => _openAddMedicationSheet(context),
                    icon: state.isAddingMedication
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add),
                    label: Text(
                      state.isAddingMedication ? 'Adding...' : 'Add Medication',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MedicationsState state) {
    if (state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == MedicationsStatus.failure &&
        state.medications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40),
              const SizedBox(height: 12),
              const Text(
                'Could not load medications.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  context.read<MedicationsBloc>().add(
                    const MedicationsRequested(),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MedicationsBloc>().add(const MedicationsRefreshed());
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (state.isRefreshing)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: LinearProgressIndicator(),
            ),
          if (state.isFromCache)
            _CacheBanner(
              onRetry: () {
                context.read<MedicationsBloc>().add(
                  const MedicationsRefreshed(),
                );
              },
            ),
          if (state.medications.isEmpty)
            const _EmptyState()
          else
            ...state.medications.map(
              (medication) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MedicationListItem(
                  medication: medication,
                  isMarkingTaken: state.isTakingMedication(medication.id),
                  isRemoving: state.isRemovingMedication(medication.id),
                  onMarkTaken: () {
                    context.read<MedicationsBloc>().add(
                      MedicationMarkTakenRequested(medication.id),
                    );
                  },
                  onRemove: () {
                    context.read<MedicationsBloc>().add(
                      MedicationRemoveRequested(medication.id),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openAddMedicationSheet(BuildContext context) async {
    final input = await showModalBottomSheet<CreateMedicationInput>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddMedicationSheet(),
    );

    if (!context.mounted || input == null) {
      return;
    }

    context.read<MedicationsBloc>().add(MedicationsAddRequested(input));
  }
}

class _CacheBanner extends StatelessWidget {
  const _CacheBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Showing cached medications. Pull to refresh or retry.',
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication_outlined, size: 36),
          SizedBox(height: 10),
          Text('No medications found.'),
        ],
      ),
    );
  }
}

class _AddMedicationSheet extends StatefulWidget {
  const _AddMedicationSheet();

  @override
  State<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<_AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();
  String _frequency = _frequencies.first;
  bool _critical = false;

  static const List<String> _frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'As needed',
    'Weekly',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: mediaQuery.viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Medication',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add a medication to your care schedule.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Medication Name',
                    hintText: 'e.g. Lisinopril',
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Medication name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dosageController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 10mg',
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Dosage is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: _frequencies
                      .map(
                        (frequency) => DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _frequency = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    hintText: 'e.g. 8:00 AM',
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Time is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _critical,
                  onChanged: (value) {
                    setState(() {
                      _critical = value ?? false;
                    });
                  },
                  title: const Text('Mark as critical medication'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: const Text('Add Medication'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      CreateMedicationInput(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _frequency,
        time: _timeController.text.trim(),
        critical: _critical,
      ),
    );
  }
}
