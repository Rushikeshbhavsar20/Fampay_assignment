abstract class FeedEvent {}

class FetchFeed extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class DismissCard extends FeedEvent {
  final int cardId;
  DismissCard(this.cardId);
}

class RemindLaterCard extends FeedEvent {
  final int cardId;
  RemindLaterCard(this.cardId);
}

class ClearAllPreferences extends FeedEvent {}
