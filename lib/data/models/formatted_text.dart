import 'package:flutter/material.dart';

class Entity {
  final String text;
  final String? color;
  final int? fontSize;
  final String? fontStyle;
  final String? fontFamily;
  final String? url;

  Entity({
    required this.text,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.fontFamily,
    this.url,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? '',
      color: json['color'],
      fontSize: json['font_size'],
      fontStyle: json['font_style'],
      fontFamily: json['font_family'],
      url: json['url'],
    );
  }

  TextStyle toTextStyle() {
    return TextStyle(
      color: color != null
          ? Color(int.parse(color!.replaceAll("#", "0xff")))
          : Colors.white, // fallback
      fontSize: fontSize?.toDouble() ?? 16,
      fontStyle: (fontStyle == 'italic') ? FontStyle.italic : FontStyle.normal,
      decoration: (fontStyle == 'underline')
          ? TextDecoration.underline
          : TextDecoration.none,
      fontWeight:
          (fontFamily?.contains("semi_bold") ?? false) // will change later
              ? FontWeight.w600
              : FontWeight.normal,
    );
  }
}

class FormattedText {
  final String text;
  final List<Entity> entities;
  final String align;

  FormattedText({
    required this.text,
    required this.entities,
    this.align = "left",
  });

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'] ?? '',
      entities: (json['entities'] as List? ?? [])
          .map((e) => Entity.fromJson(e))
          .toList(),
      align: json['align'] ?? "left",
    );
  }
}
