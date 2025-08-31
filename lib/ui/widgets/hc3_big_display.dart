import 'package:fampay_assignment/ui/widgets/formatted_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/feed_bloc.dart';
import '../../bloc/feed_event.dart';
import '../../data/models/card_group.dart';
import '../theme/app_theme.dart';

class HC3BigDisplay extends StatefulWidget {
  final CardGroup group;
  const HC3BigDisplay({super.key, required this.group});

  @override
  State<HC3BigDisplay> createState() => _HC3BigDisplayState();
}

class _HC3BigDisplayState extends State<HC3BigDisplay>
    with SingleTickerProviderStateMixin {
  static const double _corner = 12;

  bool _revealed = false;
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.35, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reveal() {
    setState(() => _revealed = true);
    _controller.forward();
  }

  void _conceal() {
    setState(() => _revealed = false);
    _controller.reverse();
  }

  Color _parseHex(String hex, {String fallback = '#FFFFFFFF'}) {
    final cleaned = (hex.isNotEmpty ? hex : fallback).replaceAll('#', '');
    final value = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(value, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final card = group.cards.first;
    final double h = (group.height ?? AppTheme.heightHC3).toDouble();

    return SizedBox(
      height: h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_corner),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RailPill(
                      icon: 'assets/icons/reminder_icon.svg',
                      labelTop: 'remind',
                      labelBottom: 'later',
                      onTap: () {
                        context.read<FeedBloc>().add(RemindLaterCard(card.id));
                        _conceal();
                      },
                    ),
                    const SizedBox(height: 20),
                    _RailPill(
                      icon: 'assets/icons/dismiss_icon.svg',
                      labelTop: 'dismiss',
                      labelBottom: 'now',
                      onTap: () {
                        context.read<FeedBloc>().add(DismissCard(card.id));
                        _conceal();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(_corner),
            child: SlideTransition(
              position: _slide,
              child: GestureDetector(
                behavior: _revealed
                    ? HitTestBehavior.translucent
                    : HitTestBehavior.opaque,
                onLongPress: _reveal,
                onTap: _revealed
                    ? _conceal
                    : () {
                        // TODO: handle card.url deeplink if needed
                      },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_corner),
                    color: card.bgColor != null
                        ? _parseHex(card.bgColor!)
                        : const Color(0xFF454AA6),
                    image: (card.bgImage != null &&
                            card.bgImage!['image_url'] != null)
                        ? DecorationImage(
                            image: NetworkImage(card.bgImage!['image_url']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      if (card.bgImage == null)
                        Positioned(
                          left: 33,
                          top: 28,
                          child: Image.asset(
                            'assets/images/placeholder.png',
                            width: 91.73,
                            height: 81.2,
                          ),
                        ),
                      Positioned(
                        left: 33,
                        bottom: 40,
                        child: SizedBox(
                          width: 260,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (card.formattedTitle != null)
                                FormattedTextWidget(
                                  formattedText: card.formattedTitle!,
                                )
                              else if ((card.title ?? '').isNotEmpty)
                                Text(
                                  card.title!,
                                  style: const TextStyle(
                                    color: Color(0xFFFBAF03),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                    height: 1.171875,
                                  ),
                                ),
                              const SizedBox(height: 28),
                              if (card.formattedDescription != null)
                                FormattedTextWidget(
                                  formattedText: card.formattedDescription!,
                                )
                              else if ((card.description ?? '').isNotEmpty)
                                Text(
                                  card.description!,
                                  style: AppTheme.bodySmall,
                                ),
                              const SizedBox(height: 29),
                              if (card.ctas.isNotEmpty)
                                Container(
                                  width: 128,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF000000),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      card.ctas.first.text,
                                      style: AppTheme.buttonText,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailPill extends StatelessWidget {
  final String icon;
  final String labelTop;
  final String labelBottom;
  final VoidCallback onTap;

  const _RailPill({
    required this.icon,
    required this.labelTop,
    required this.labelBottom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(height: 8),
                Text(
                  '$labelTop $labelBottom',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
