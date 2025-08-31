class AppConstants {
  // API endpoints
  static const String baseUrl = 'https://polyjuice.kong.fampay.co';
  static const String feedEndpoint = '/mock/famapp/feed/home_section/';

  // Shared preferences keys
  static const String dismissedIdsKey = 'dismissed_ids';
  static const String snoozedIdsKey = 'snoozed_ids';

  // Card types
  static const String hc1Type = 'HC1';
  static const String hc3Type = 'HC3';
  static const String hc5Type = 'HC5';
  static const String hc6Type = 'HC6';
  static const String hc9Type = 'HC9';

  // Card heights
  static const double heightHC1 = 64.0;
  static const double heightHC3 = 350.0;
  static const double heightHC5 = 180.0;
  static const double heightHC6 = 35.0;
  static const double heightHC9 = 180.0;

  // Spacing
  static const double cardSpacing = 12.0;
  static const double cardPadding = 16.0;
  static const double borderRadius = 12.0;

  // Text sizes
  static const double titleFontSize = 16.0;
  static const double bodyFontSize = 13.0;
  static const double smallFontSize = 12.0;

  // Colors
  static const String defaultBgColor = '#F7F6F3';
  static const String defaultTextColor = '#000000';
  static const String defaultAccentColor = '#FBAF03';

  // Error message
  static const String feedLoadError = 'Failed to load feed';
}
