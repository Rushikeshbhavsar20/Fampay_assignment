class CTA {
  final String text;
  final String? url;
  final String? bgColor;
  final String? textColor;

  CTA({
    required this.text,
    this.url,
    this.bgColor,
    this.textColor,
  });

  factory CTA.fromJson(Map<String, dynamic> json) {
    return CTA(
      text: json['text'] ?? '',
      url: json['url'] ?? '',
      bgColor: json['bg_color'] ?? '#000000',
      textColor: json['text_color'] ?? '#FFFFFF',
    );
  }
}
