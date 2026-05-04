import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';
import 'package:compasscare_flutter/features/shopping/domain/models/shopping_models.dart';
import 'package:compasscare_flutter/features/shopping/domain/repositories/shopping_repository.dart';

class ShoppingRepositoryImpl implements ShoppingRepository {
  const ShoppingRepositoryImpl({
    required MedicationsRepository medicationsRepository,
  }) : _medicationsRepository = medicationsRepository;

  final MedicationsRepository _medicationsRepository;

  static const List<ShoppingLink> _featuredLinks = [
    ShoppingLink(
      id: 'featured-medication-supplies',
      title: 'Medication Supplies',
      subtitle: 'Pill organizers, dispensers, reminders',
      url: compassCareAmazonStoreUrl,
    ),
    ShoppingLink(
      id: 'featured-health-monitoring',
      title: 'Health Monitoring',
      subtitle: 'Blood pressure monitors, thermometers, scales',
      url: compassCareAmazonStoreUrl,
    ),
  ];

  static const List<ShoppingLink> _categoryLinks = [
    ShoppingLink(
      id: 'category-daily-living-aids',
      title: 'Daily Living Aids',
      subtitle: 'Grab bars, shower chairs, reachers',
      url: compassCareAmazonStoreUrl,
    ),
    ShoppingLink(
      id: 'category-mobility',
      title: 'Mobility',
      subtitle: 'Walkers, canes, wheelchairs',
      url: compassCareAmazonStoreUrl,
    ),
    ShoppingLink(
      id: 'category-medical-supplies',
      title: 'Medical Supplies',
      subtitle: 'Bandages, gauze, medical tape',
      url: compassCareAmazonStoreUrl,
    ),
    ShoppingLink(
      id: 'category-nutrition',
      title: 'Nutrition',
      subtitle: 'Supplements, protein shakes, meal replacements',
      url: compassCareAmazonStoreUrl,
    ),
    ShoppingLink(
      id: 'category-safety-comfort',
      title: 'Safety & Comfort',
      subtitle: 'Bed rails, non-slip mats, cushions',
      url: compassCareAmazonStoreUrl,
    ),
  ];

  @override
  Future<ShoppingLoadResult> loadShoppingData() async {
    final fallbackData = const ShoppingData(
      featuredLinks: _featuredLinks,
      categoryLinks: _categoryLinks,
      medicationNames: [],
    );

    try {
      final medicationResult = await _medicationsRepository.fetchMedications();
      final names = medicationResult.medications
          .map((medication) => medication.name)
          .where((name) => name.trim().isNotEmpty)
          .take(3)
          .toList(growable: false);

      final data = ShoppingData(
        featuredLinks: _featuredLinks,
        categoryLinks: _categoryLinks,
        medicationNames: names,
      );

      final origin = medicationResult.origin == MedicationDataOrigin.network
          ? ShoppingDataOrigin.network
          : ShoppingDataOrigin.cache;

      return ShoppingLoadResult(data: data, origin: origin);
    } catch (_) {
      return ShoppingLoadResult(
        data: fallbackData,
        origin: ShoppingDataOrigin.staticOnly,
      );
    }
  }
}
