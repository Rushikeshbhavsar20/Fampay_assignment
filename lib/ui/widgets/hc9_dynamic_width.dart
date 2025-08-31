import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/card_group.dart';
import '../theme/app_theme.dart';

class HC9DynamicWidth extends StatelessWidget {
  final CardGroup group;
  const HC9DynamicWidth({super.key, required this.group});

  // Parse "#RRGGBB" or "#AARRGGBB"
  Color _parseHex(String hex) {
    final s = hex.replaceAll('#', '');
    final withAlpha = (s.length == 6) ? 'FF$s' : s;
    return Color(int.parse(withAlpha, radix: 16));
  }

  LinearGradient? _buildGradient(Map<String, dynamic>? grad) {
    if (grad == null) return null;
    final raw = grad['colors'];
    if (raw is! List || raw.isEmpty) return null;

    final colors = raw.whereType<String>().map(_parseHex).toList();
    final angleDeg =
        (grad['angle'] is num) ? (grad['angle'] as num).toDouble() : 0.0;
    return LinearGradient(
      colors: colors,
      transform: GradientRotation(angleDeg * math.pi / 180.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // HC9: fixed height from parent; width per card = height * aspect_ratio
    final double h = (group.height ?? AppTheme.heightHC9).toDouble();

    return SizedBox(
      height: h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
        child: Row(
          children: [
            for (final card in group.cards) ...[
              _HC9Tile(height: h, card: card, buildGradient: _buildGradient),
              const SizedBox(width: AppTheme.spacingS),
            ],
          ],
        ),
      ),
    );
  }
}

class _HC9Tile extends StatelessWidget {
  final double height;
  final dynamic card;
  final LinearGradient? Function(Map<String, dynamic>?) buildGradient;

  const _HC9Tile({
    required this.height,
    required this.card,
    required this.buildGradient,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? bgImg =
        (card.bgImage is Map<String, dynamic>) ? card.bgImage : null;
    final double aspect = (bgImg?['aspect_ratio'] is num)
        ? (bgImg!['aspect_ratio'] as num).toDouble()
        : 1.0;

    // width = height * (width/height)
    final double w = height * (aspect == 0 ? 1.0 : aspect);

    final String? imgUrl = bgImg?['image_url'] as String?;
    final gradient = buildGradient(card.bgGradient);

    return SizedBox(
      width: w,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Stack(
          children: [
            // Base image or fallback color
            if (imgUrl != null && imgUrl.isNotEmpty)
              Image.network(imgUrl, fit: BoxFit.cover, width: w, height: height)
            else if (gradient != null)
              Container(
                width: w,
                height: height,
                decoration: BoxDecoration(gradient: gradient),
              )
            else
              Container(
                width: w,
                height: height,
                color: Colors.black12,
              ),

            // Gradient overlay (when both image and gradient exist)
            if (gradient != null && imgUrl != null && imgUrl.isNotEmpty)
              Container(
                width: w,
                height: height,
                decoration: BoxDecoration(gradient: gradient),
                child: Container(color: Colors.transparent),
              ),
          ],
        ),
      ),
    );
  }
}
