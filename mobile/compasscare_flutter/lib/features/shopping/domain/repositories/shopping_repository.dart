import 'package:compasscare_flutter/features/shopping/domain/models/shopping_models.dart';
import 'package:equatable/equatable.dart';

enum ShoppingDataOrigin { network, cache, staticOnly }

class ShoppingLoadResult extends Equatable {
  const ShoppingLoadResult({required this.data, required this.origin});

  final ShoppingData data;
  final ShoppingDataOrigin origin;

  @override
  List<Object?> get props => [data, origin];
}

abstract class ShoppingRepository {
  Future<ShoppingLoadResult> loadShoppingData();
}
