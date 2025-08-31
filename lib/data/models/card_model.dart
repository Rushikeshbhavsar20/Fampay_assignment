import 'cta.dart';
import 'formatted_text.dart';

class CardModel {
  final int id;
  final String? title;
  final String? description;
  final String? url;
  final String? bgColor;
  final Map<String, dynamic>? bgImage;
  final Map<String, dynamic>? bgGradient;
  final List<CTA> ctas;
  final FormattedText? formattedTitle;
  final FormattedText? formattedDescription;
  final Map<String, dynamic>? icon;
  final int? iconSize;

  CardModel(
      {required this.id,
      this.title,
      this.description,
      this.url,
      this.bgColor,
      this.bgImage,
      this.bgGradient,
      this.ctas = const [],
      this.formattedTitle,
      this.formattedDescription,
      this.icon,
      this.iconSize});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      bgColor: json['bg_color'],
      bgImage: json['bg_image'],
      bgGradient: json['bg_gradient'],
      ctas: (json['cta'] as List? ?? []).map((e) => CTA.fromJson(e)).toList(),
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      icon: json['icon'],
      iconSize: json['icon_size'],
    );
  }
}
