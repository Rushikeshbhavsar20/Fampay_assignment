import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bloc/feed_bloc.dart';

import 'data/feed_repository.dart';
import 'ui/contextual_cards_container.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const FamPayApp());
}

class FamPayApp extends StatelessWidget {
  const FamPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FeedRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) =>
              FeedBloc(repository: context.read<FeedRepository>()),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppTheme.backgroundColor,
              surfaceTintColor: Colors.transparent,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'fampay',
                    style: AppTheme.appBarTitle,
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/fampay_logo.svg',
                    width: 22,
                    height: 23,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                child: Container(
                  padding: const EdgeInsets.only(top: AppTheme.spacingXL),
                  color: AppTheme.surfaceColor,
                  child: const ContextualCardsContainer(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
