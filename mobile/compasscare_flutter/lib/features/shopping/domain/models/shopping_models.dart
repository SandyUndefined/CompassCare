import 'package:equatable/equatable.dart';

const compassCareAmazonStoreUrl =
    'https://www.amazon.com/shop/profile/amzn1.account.AFTX5PT2EFQFNPZ2JKPI5EQVVSJQ/list/I3EWL8ZC90V4?ref_=cm_sw_r_cp_ud_aipsflist_2RH8YX61303FZ9NTN55X&ccs_id=be71c7ea-9d4d-4ac5-99b7-51b638ba32ea';

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
