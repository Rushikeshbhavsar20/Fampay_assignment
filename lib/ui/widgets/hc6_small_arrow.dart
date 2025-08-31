import 'package:fampay_assignment/ui/widgets/formatted_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/card_group.dart';
import '../theme/app_theme.dart';

class HC6SmallArrow extends StatelessWidget {
  final CardGroup group;
  const HC6SmallArrow({super.key, required this.group});

  Color _parseHex(String hex, {String fallback = '#FFFFFFFF'}) {
    final cleaned = (hex.isNotEmpty ? hex : fallback).replaceAll('#', '');
    final value = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(value, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final double h = group.height ?? AppTheme.heightHC6;

    Widget buildTile(card) {
      final bg = card.bgColor != null ? _parseHex(card.bgColor!) : Colors.white;

      // Extract icon properties from API
      final Map<String, dynamic>? iconMap =
          (card.icon is Map<String, dynamic>) ? card.icon : null;
      final String? iconUrl = iconMap?['image_url'] as String?;
      final num? aspectRatioRaw = iconMap?['aspect_ratio'] as num?;
      final double? aspectRatio = aspectRatioRaw?.toDouble();

      // Use API icon_size or fallback
      final double iconSize = (card.iconSize ?? 24).toDouble();
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
              if ((card.url ?? '').isNotEmpty) {
                final uri = Uri.tryParse(card.url!);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
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
                  Expanded(
                    child: (card.formattedTitle != null)
                        ? FormattedTextWidget(
                            formattedText: card.formattedTitle!,
                            maxLines: 1,
                            fallbackStyle: AppTheme.titleLarge,
                          )
                        : Text(
                            (card.title ?? '').trim().isEmpty
                                ? ' '
                                : card.title!,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            softWrap: false,
                            style: AppTheme.titleLarge,
                          ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black87),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // If multiple cards:
    if (group.cards.length > 1 && group.isScrollable) {
      // Horizontal scrollable row of HC6 tiles
      return SizedBox(
        height: h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
          itemBuilder: (_, i) => SizedBox(
            width: MediaQuery.sizeOf(_).width * 0.85,
            child: buildTile(group.cards[i]),
          ),
          separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingS),
          itemCount: group.cards.length,
        ),
      );
    } else if (group.cards.length > 1 && !group.isScrollable) {
      return SizedBox(
        height: h,
        child: Row(
          children: group.cards
              .map<Widget>((c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS),
                      child: buildTile(c),
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      // Single card - check if it should be full width
      final card = group.cards.first;
      final bool isFullWidth = group.isScrollable == false &&
          (group.height == 32 || group.height == 35);
      if (isFullWidth) {
        return buildTile(card);
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
          child: buildTile(card),
        );
      }
    }
  }
}
