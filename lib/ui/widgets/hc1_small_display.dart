import 'package:fampay_assignment/ui/widgets/formatted_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/card_group.dart';
import '../theme/app_theme.dart';

class HC1SmallDisplay extends StatelessWidget {
  final CardGroup group;
  const HC1SmallDisplay({super.key, required this.group});

  Color _parseHex(String hex, {String fallback = '#FFFFFFFF'}) {
    final s = (hex.isNotEmpty ? hex : fallback).replaceAll('#', '');
    final withAlpha = s.length == 6 ? 'FF$s' : s; // default alpha
    return Color(int.parse(withAlpha, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final double h =
        (group.height ?? AppTheme.heightHC1).toDouble(); // HC1 = fixed height
    final cards = group.cards;

    Widget buildTile(card) {
      final bg = (card.bgColor != null && card.bgColor!.isNotEmpty)
          ? _parseHex(card.bgColor!)
          : Colors.white;

      final Map<String, dynamic>? iconMap =
          (card.icon is Map<String, dynamic>) ? card.icon : null;
      final String? iconUrl = iconMap?['image_url'] as String?;
      final num? aspectRatioRaw = iconMap?['aspect_ratio'] as num?;
      final double? aspectRatio = aspectRatioRaw?.toDouble();

      final double iconSize = h * 0.7;
      final double iconWidth = iconSize;
      final double iconHeight =
          aspectRatio != null ? iconSize * aspectRatio : iconSize;

      return Container(
        height: h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            onTap: () async {
              final u = (card.url ?? '').trim();
              if (u.isNotEmpty) {
                final uri = Uri.tryParse(u);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon section - show image if available, otherwise fallback to Flutter icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    child: iconUrl != null && iconUrl.isNotEmpty
                        ? Image.network(
                            iconUrl,
                            width: iconWidth,
                            height: iconHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to Flutter icon if image fails to load
                              return Container(
                                width: iconWidth,
                                height: iconHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusS),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: iconSize * 0.6,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            width: iconWidth,
                            height: iconHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusS),
                            ),
                            child: Icon(
                              Icons.person,
                              size: iconSize * 0.6,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),

                  // Text block
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (card.formattedTitle != null)
                          FormattedTextWidget(
                            formattedText: card.formattedTitle!,
                          )
                        else if ((card.title ?? '').trim().isNotEmpty)
                          Text(
                            card.title!.trim(),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: AppTheme.titleLarge,
                          ),

                        // Small spacing between title and description if both exist
                        if (card.formattedDescription != null ||
                            ((card.description ?? '').trim().isNotEmpty))
                          const SizedBox(height: 2),

                        if (card.formattedDescription != null)
                          FormattedTextWidget(
                            formattedText: card.formattedDescription!,
                          )
                        else if ((card.description ?? '').trim().isNotEmpty)
                          Text(
                            card.description!.trim(),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: AppTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Multiple cards behavior
    if (cards.length > 1 && group.isScrollable) {
      return SizedBox(
        height: h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
          itemCount: cards.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingS),
          itemBuilder: (ctx, i) => SizedBox(
            width: MediaQuery.sizeOf(ctx).width * 0.9,
            child: buildTile(cards[i]),
          ),
        ),
      );
    } else if (cards.length > 1 && !group.isScrollable) {
      // No scroll: fit all in one row with equal widths
      return SizedBox(
        height: h,
        child: Row(
          children: cards
              .map<Widget>(
                (c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS),
                    child: buildTile(c),
                  ),
                ),
              )
              .toList(),
        ),
      );
    } else {
      // Single full-width HC1
      final card = cards.first;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
        child: buildTile(card),
      );
    }
  }
}
