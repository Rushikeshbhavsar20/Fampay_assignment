import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/feed_repository.dart';
import '../data/models/card_group.dart';
import '../ui/constants/app_constants.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository repository;

  SharedPreferences? _prefs;
  static const _kDismissed = AppConstants.dismissedIdsKey; // persist forever
  static const _kSnoozed = AppConstants.snoozedIdsKey;
  Set<int> _snoozed = <int>{}; // session-only, loaded from prefs

  //_rawGroups are actual data with all cards
  //_FilteredView will remove the id of removed cards from list.

  List<CardGroup> _rawGroups = const <CardGroup>[]; // last fetched feed

  FeedBloc({required this.repository}) : super(FeedLoading()) {
    on<FetchFeed>(_onFetch);
    on<RefreshFeed>(_onRefresh);
    on<RemindLaterCard>(_onRemindLater);
    on<DismissCard>(_onDismiss);
    on<ClearAllPreferences>(_onClearAllPreferences);

    _clearSnoozedCards();

    add(FetchFeed());
  }

  /// Clear snoozed cards on app start so they reappear
  Future<void> _clearSnoozedCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kSnoozed);
      _snoozed.clear();
    } catch (e) {
      // Error
    }
  }

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    // Load snoozed cards from preferences
    if (_snoozed.isEmpty) {
      final snoozedList = _prefs!.getStringList(_kSnoozed) ?? <String>[];
      _snoozed = snoozedList.map((id) => int.parse(id)).toSet();
    }
  }

  Future<void> _onFetch(FetchFeed e, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      await _ensurePrefs();
      _rawGroups = await repository.fetchFeed(); // store the source

      final filteredView = _filteredView();

      emit(FeedLoaded(filteredView));
    } catch (err) {
      emit(FeedError(err.toString()));
    }
  }

  Future<void> _onRefresh(RefreshFeed e, Emitter<FeedState> emit) async {
    try {
      await _ensurePrefs();
      _rawGroups = await repository.fetchFeed(); // refresh source
      emit(FeedLoaded(_filteredView()));
    } catch (err) {
      emit(FeedError(err.toString()));
    }
  }

  Future<void> _onRemindLater(
      RemindLaterCard e, Emitter<FeedState> emit) async {
    await _ensurePrefs();
    _snoozed.add(e.cardId); // add to session set

    // Persist snoozed cards to preferences
    final snoozedList = _snoozed.map((id) => id.toString()).toList();
    await _prefs!.setStringList(_kSnoozed, snoozedList);

    final filteredView = _filteredView();

    emit(FeedLoaded(filteredView));
  }

  Future<void> _onDismiss(DismissCard e, Emitter<FeedState> emit) async {
    await _ensurePrefs();
    final list = _prefs!.getStringList(_kDismissed) ?? <String>[];
    final set = list.toSet()..add(e.cardId.toString());
    await _prefs!.setStringList(_kDismissed, set.toList());

    final filteredView = _filteredView();
    emit(FeedLoaded(filteredView));
  }

  Future<void> _onClearAllPreferences(
      ClearAllPreferences e, Emitter<FeedState> emit) async {
    await _ensurePrefs();
    await _prefs!.clear();
    _snoozed.clear();

    emit(FeedLoaded(_filteredView()));
  }

  List<CardGroup> _filteredView() {
    final dismissedIds = <int>{};
    final snoozedIds = <int>{};

    try {
      // Get dismissed IDs from preferences
      if (_prefs != null) {
        final dismissedList = _prefs!.getStringList(_kDismissed) ?? <String>[];
        dismissedIds.addAll(dismissedList.map((id) => int.parse(id)));
      }

      // Get snoozed IDs from session
      snoozedIds.addAll(_snoozed);
    } catch (e) {
      // Handle errors
    }

    final result = <CardGroup>[];
    for (final g in _rawGroups) {
      final kept = g.cards
          .where(
              (c) => !dismissedIds.contains(c.id) && !snoozedIds.contains(c.id))
          .toList();

      // Only add groups that have visible cards
      if (kept.isNotEmpty) {
        result.add(CardGroup(
          id: g.id,
          designType: g.designType,
          cards: kept,
          isScrollable: g.isScrollable,
          height: g.height,
        ));
      }
    }

    return result;
  }
}
