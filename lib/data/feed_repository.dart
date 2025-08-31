import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/card_group.dart';
import '../ui/constants/app_constants.dart';

class FeedRepository {
  Future<List<CardGroup>> fetchFeed() async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.feedEndpoint}?slugs=famx-paypage');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body[0]['hc_groups'] as List)
          .map((e) => CardGroup.fromJson(e))
          .toList();
    } else {
      throw Exception(AppConstants.feedLoadError);
    }
  }
}
