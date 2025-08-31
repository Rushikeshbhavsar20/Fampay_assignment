import '../data/models/card_group.dart';

abstract class FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<CardGroup> groups;
  FeedLoaded(this.groups);
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
