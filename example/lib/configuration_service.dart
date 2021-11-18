import 'package:flutter/material.dart';
import 'package:trufi_core/blocs/configuration/configuration.dart';
import 'package:trufi_core/blocs/configuration/models/animation_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/language_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/map_configuration.dart';
import 'package:trufi_core/blocs/configuration/models/url_collection.dart';

import 'package:latlong2/latlong.dart';

Configuration setupExampleConfiguration() {
  // Urls
  final urls = UrlCollection(
    openTripPlannerUrl: "https://api.trufi.app/otp/routers/default",
  );

  // Map
  final map = MapConfiguration(
    center: LatLng(-17.39000, -66.15400),
    southWest: LatLng(-17.79300, -66.75000),
    northEast: LatLng(-16.90400, -65.67400),
  );

  // Languages
  final languages = [
    LanguageConfiguration("de", "DE", "Deutsch"),
    LanguageConfiguration("en", "US", "English"),
    LanguageConfiguration("es", "ES", "Español", isDefault: true),
    LanguageConfiguration("fr", "FR", "Français"),
    LanguageConfiguration("it", "IT", "Italiano"),
    LanguageConfiguration("qu", "BO", "Quechua simi"),
  ];

  final customTranslations = TrufiCustomLocalizations()
    ..title = {
      const Locale("de"): "Trufi App (German)",
      const Locale("en", "US"): "Trufi App (English)"
    }
    ..tagline = {
      const Locale("de"): "Tagline (German)",
      const Locale("en", "US"): "Tagline (English)"
    };

  return Configuration(
    customTranslations: customTranslations,
    supportedLanguages: languages,
    animations: AnimationConfiguration(),
    map: map,
    urls: urls,
    // feedbackDefinition: FeedbackDefinition(
    //   FeedBackType.email,
    //   "info@trufi.app",
    // ),
  );
}
