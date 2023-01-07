import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/place_suggestion_model.dart';
import '../../../data/repository/maps_repository.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  void emitPlaceSuggestions(String place, String sessionToken) {
    mapsRepository.fetchSuggestionsPlaces(place, sessionToken).then(
      (suggestions) {
        emit(PlacesLoaded(suggestions));
      },
    );
  }
}
