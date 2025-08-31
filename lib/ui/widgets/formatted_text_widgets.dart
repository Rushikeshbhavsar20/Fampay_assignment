import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/formatted_text.dart';

class FormattedTextWidget extends StatelessWidget {
  final FormattedText formattedText;

  /// max lines (null = unlimited). If set, extra text will be cut off.
  final int? maxLines;
  final TextStyle fallbackStyle;

  const FormattedTextWidget({
    super.key,
    required this.formattedText,
    this.maxLines,
    this.fallbackStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  });

  TextAlign _mapAlign() {
    switch (formattedText.align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    int entityIndex = 0;
    // check {} and entities if there add Textstyle to spans if not use default style.
    for (int i = 0; i < formattedText.text.length; i++) {
      final ch = formattedText.text[i];
      if (ch == '{' &&
          i + 1 < formattedText.text.length &&
          formattedText.text[i + 1] == '}' &&
          entityIndex < formattedText.entities.length) {
        final e = formattedText.entities[entityIndex];
        spans.add(
          TextSpan(
            text: e.text,
            style: e.toTextStyle().merge(TextStyle(
                  color: e.color == null ? fallbackStyle.color : null,
                )),
            recognizer: e.url != null
                ? (TapGestureRecognizer()
                  ..onTap = () async {
                    final uri = Uri.tryParse(e.url!);
                    if (uri != null) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  })
                : null,
          ),
        );
        entityIndex++;
        i++;
      } else {
        spans.add(TextSpan(text: ch, style: fallbackStyle));
      }
    }

    return Text.rich(
      TextSpan(children: spans, style: fallbackStyle),
      textAlign: _mapAlign(),
      maxLines: maxLines,
      overflow: TextOverflow.clip,
      softWrap: true,
    );
  }
}
