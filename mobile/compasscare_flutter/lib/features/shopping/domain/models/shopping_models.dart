import 'package:equatable/equatable.dart';

class ShoppingLink extends Equatable {
  const ShoppingLink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  final String id;
  final String title;
  final String subtitle;
  final String url;

  @override
  List<Object?> get props => [id, title, subtitle, url];
}

class ShoppingData extends Equatable {
  const ShoppingData({
    required this.featuredLinks,
    required this.categoryLinks,
    required this.medicationNames,
  });

  final List<ShoppingLink> featuredLinks;
  final List<ShoppingLink> categoryLinks;
  final List<String> medicationNames;

  @override
  List<Object?> get props => [featuredLinks, categoryLinks, medicationNames];
}
