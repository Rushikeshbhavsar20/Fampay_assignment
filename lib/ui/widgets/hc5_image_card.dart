import 'package:flutter/material.dart';
import '../../data/models/card_group.dart';
import '../theme/app_theme.dart';

class HC5ImageCard extends StatelessWidget {
  final CardGroup group;
  const HC5ImageCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: group.cards.map((c) {
        return Container(
          decoration: BoxDecoration(
            color: c.bgColor != null && c.bgColor!.isNotEmpty
                ? Color(
                    int.parse('FF${c.bgColor!.replaceAll('#', '')}', radix: 16))
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          // Dynamic height based on aspect ratio from API
          height: c.bgImage != null && c.bgImage!['aspect_ratio'] != null
              ? MediaQuery.of(context).size.width / c.bgImage!['aspect_ratio']!
              : AppTheme.heightHC5, // Fallback to default height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            child: Stack(
              children: [
                // Background Image with fallback to placeholder
                Positioned.fill(
                  child: c.bgImage != null && c.bgImage!['image_url'] != null
                      ? Image.network(
                          c.bgImage!['image_url']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Text(
                      c.title ?? "HC5 Card",
                      style: AppTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
