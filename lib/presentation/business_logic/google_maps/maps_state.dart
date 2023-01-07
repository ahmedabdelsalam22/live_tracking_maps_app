part of 'maps_cubit.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class PlacesLoaded extends MapsState {
  final List<PlaceSuggestionModel> places;

  PlacesLoaded(this.places);
}
