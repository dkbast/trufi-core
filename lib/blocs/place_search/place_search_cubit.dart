import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/location/location_search_storage.dart';
import 'package:trufi_core/models/trufi_place.dart';

part 'place_search_state.dart';

class LocationSearchBloc extends Cubit<PlaceSearchState> {
  LocationSearchBloc(BuildContext context)
      : super(PlaceSearchState(
          LocationSearchStorage(),
        )) {
    state.storage.load(context, "assets/data/search.json");
  }

  LocationSearchStorage get storage => state.storage;

  Future<List<TrufiLocation>> fetchPlaces(BuildContext context) {
    return state.storage.fetchPlaces(context);
  }
}
