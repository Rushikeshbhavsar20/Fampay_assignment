import 'card_model.dart';

class CardGroup {
  final int id;
  final String designType;
  final List<CardModel> cards;
  final bool isScrollable;
  final double? height;

  CardGroup({
    required this.id,
    required this.designType,
    required this.cards,
    required this.isScrollable,
    this.height,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      id: json['id'],
      designType: json['design_type'],
      cards: (json['cards'] as List).map((c) => CardModel.fromJson(c)).toList(),
      isScrollable: json['is_scrollable'] ?? false,
      height: (json['height'] as num?)?.toDouble(),
    );
  }
}
