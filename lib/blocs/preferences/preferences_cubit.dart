import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core/blocs/preferences/preferences.dart';
import 'package:trufi_core/repository/entities/weather_info.dart';
import 'package:trufi_core/repository/local_repository.dart';
import 'package:trufi_core/repository/shared_preferences_repository.dart';
import 'package:uuid/uuid.dart';

class PreferencesCubit extends Cubit<PreferenceState> {
  LocalRepository localRepository = SharedPreferencesRepository();
  final LatLng currentLocation;

  PreferencesCubit(PreferenceState initState, this.currentLocation)
      : super(initState) {
    _load();
  }

  Future<void> _load() async {
    String correlationId = await localRepository.getCorrelationId();
    WeatherInfo weatherInfo;

    // Generate new UUID if missing
    if (correlationId == null) {
      correlationId = const Uuid().v4();
      await localRepository.saveCorrelationId(correlationId);
    }

    emit(
      state.copyWith(
        correlationId: correlationId,
        languageCode: await localRepository.getLanguageCode(),
        weatherInfo: weatherInfo,
      ),
    );
  }

  Future<void> updateLanguage(String languageCode) async {
    localRepository.saveLanguageCode(languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }
}
