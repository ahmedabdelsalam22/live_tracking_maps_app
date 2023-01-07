import '../model/place_suggestion_model.dart';
import '../web_services/places_web_services.dart';

class MapsRepository {
  final PlacesWebservices placesWebservices;

  MapsRepository(this.placesWebservices);

  Future<List<PlaceSuggestionModel>> fetchSuggestionsPlaces(
      String place, String sessionToken) async {
    final suggestions =
        await placesWebservices.fetchSuggestionsPlaces(place, sessionToken);

    return suggestions
        .map((suggestion) => PlaceSuggestionModel.fromJson(suggestion))
        .toList();
  }
}
