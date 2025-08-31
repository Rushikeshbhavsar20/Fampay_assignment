import 'package:fampay_assignment/bloc/feed_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_state.dart';
import 'widgets/hc1_small_display.dart';
import 'widgets/hc3_big_display.dart';
import 'widgets/hc5_image_card.dart';
import 'widgets/hc6_small_arrow.dart';
import 'widgets/hc9_dynamic_width.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';

class ContextualCardsContainer extends StatelessWidget {
  const ContextualCardsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is FeedLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().add(RefreshFeed());
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppTheme.spacingM,
                  AppTheme.spacingM, AppTheme.spacingM, AppTheme.spacingXXL),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];

                return KeyedSubtree(
                  key: ValueKey(
                      'group_${group.id}_${group.cards.map((c) => c.id).join('_')}'),
                  child: () {
                    switch (group.designType) {
                      case AppConstants.hc1Type:
                        return HC1SmallDisplay(group: group);
                      case AppConstants.hc3Type:
                        return HC3BigDisplay(group: group);
                      case AppConstants.hc5Type:
                        return HC5ImageCard(group: group);
                      case AppConstants.hc6Type:
                        return HC6SmallArrow(group: group);
                      case AppConstants.hc9Type:
                        return HC9DynamicWidth(group: group);
                      default:
                        return const SizedBox.shrink();
                    }
                  }(),
                );
              },
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppTheme.spacingM),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
