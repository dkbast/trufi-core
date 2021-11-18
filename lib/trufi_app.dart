import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trufi_core/blocs/app_review_cubit.dart';
import 'package:trufi_core/blocs/configuration/configuration.dart';
import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';
import 'package:trufi_core/blocs/configuration/models/language_configuration.dart';
import 'package:trufi_core/blocs/home_page_cubit.dart';
import 'package:trufi_core/blocs/panel/panel_cubit.dart';
import 'package:trufi_core/blocs/preferences/preferences.dart';
import 'package:trufi_core/blocs/theme/theme_bloc.dart';
import 'package:trufi_core/blocs/theme/theme_state.dart';
import 'package:trufi_core/l10n/material_localization_qu.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/repository/shared_preferences_repository.dart';
import 'package:trufi_core/services/plan_request/online_graphql_repository/online_graphql_repository.dart';
import 'package:trufi_core/services/plan_request/request_manager.dart';
import './blocs/preferences/preferences_cubit.dart';
import 'blocs/custom_layer/custom_layers_cubit.dart';
import 'blocs/gps_location/location_provider_cubit.dart';
import 'blocs/map_tile_provider/map_tile_provider_cubit.dart';
import 'blocs/payload_data_plan/payload_data_plan_cubit.dart';
import 'blocs/place_search/place_search_cubit.dart';
import 'blocs/search_locations/search_locations_cubit.dart';
import 'models/custom_layer.dart';
import 'models/map_tile_provider.dart';
import 'services/plan_request/online_repository.dart';
import 'services/search_location/offline_search_location.dart';
import 'services/search_location/search_location_manager.dart';

/// Signature for a function that creates a widget with the current [Locale],
/// e.g. [StatelessWidget.build] or [State.build].
///
/// See also:
///
///  * [IndexedWidgetBuilder], which is similar but also takes an index.
///  * [TransitionBuilder], which is similar but also takes a child.
///  * [ValueWidgetBuilder], which is similar but takes a value and a child.
typedef LocaleWidgetBuilder = Widget Function(
    BuildContext context, Locale locale);

/// The [TrufiApp] is the main Widget of the application
///
/// The [customOverlayBuilder] allows you to add an host controlled overlay
/// on top of the Trufi Map. It is located from the left side of the screen
/// until the beginning of the Fab buttons.
///
/// Starting from the Fab buttons you are able to add the [customBetweenFabBuilder]
/// to add a customOverlay between the two Fab Buttons on the right side.
///
/// ```dart
///   @override
///   Widget build(BuildContext context) {
///     return TrufiApp(
///       theme: theme,
///       customOverlayBuilder: (context, locale) => Placeholder(),
///       customBetweenFabBuilder: (context) => Placeholder(),
///     ),
///   }
/// ```
///
class TrufiApp extends StatelessWidget {
  const TrufiApp({
    @required this.configuration,
    Key key,
    this.customLayers = const [],
    this.mapTileProviders,
    this.searchLocationManager,
    @required this.customRequestManager,
    this.providers = const [],
    @required this.trufiRoutes,
    this.theme,
  }) : super(key: key);

  /// Main Configurations for the TrufiCore it contains information about
  /// Feedback, Emails and Contributors.
  final Configuration configuration;

  /// The used [CustomTheme] used for the whole Trufi App
  final CustomTheme theme;

  /// List of [CustomLayerContainer] implementations
  final List<CustomLayerContainer> customLayers;

  /// List of Map Tile Provider
  /// if the list is [null] or [Empty], [Trufi Core] then will be used [OSMDefaultMapTile]
  final List<MapTileProvider> mapTileProviders;

  ///You can provider a [SearchLocationManager]
  ///By defaul [Trufi-Core] has implementation
  /// [OfflineSearchLocation] that used the assets/data/search.json
  final SearchLocationManager searchLocationManager;

  /// Optional extension implement your [customRequestManager]
  /// By default will be used the [OnlineRepository] or [OnlineGraphQLRepository]
  final RequestManager customRequestManager;

  final List<SingleChildWidget> providers;
  final RouteMap trufiRoutes;
  @override
  Widget build(BuildContext context) {
    final sharedPreferencesRepository = SharedPreferencesRepository();
    return MultiProvider(
      providers: [
        BlocProvider<ConfigurationCubit>(
          create: (context) => ConfigurationCubit(configuration),
        ),
        BlocProvider<PanelCubit>(
          create: (context) => PanelCubit(),
        ),
        BlocProvider<PreferencesCubit>(
          create: (context) => PreferencesCubit(
            PreferenceState(
              languageCode: configuration.supportedLanguages
                  .firstWhere(
                    (element) => element.isDefault,
                    orElse: () => LanguageConfiguration("en", "", "English"),
                  )
                  .languageCode,
            ),
            // configuration.map.center,
          ),
        ),
        BlocProvider<CustomLayersCubit>(
          create: (context) => CustomLayersCubit(customLayers),
        ),
        BlocProvider<LocationSearchBloc>(
          create: (context) => LocationSearchBloc(context),
        ),
        BlocProvider<MapTileProviderCubit>(
          create: (context) => MapTileProviderCubit(
            mapTileProviders:
                mapTileProviders != null && mapTileProviders.isNotEmpty
                    ? mapTileProviders
                    : [OSMDefaultMapTile()],
          ),
        ),
        BlocProvider<AppReviewCubit>(
          create: (context) => AppReviewCubit(
            configuration.minimumReviewWorthyActionCount,
            sharedPreferencesRepository,
          ),
        ),
        BlocProvider<SearchLocationsCubit>(
          create: (context) => SearchLocationsCubit(
            searchLocationManager ?? OfflineSearchLocation(),
          ),
        ),
        BlocProvider<HomePageCubit>(
          create: (context) {
            return HomePageCubit(
              sharedPreferencesRepository,
              customRequestManager,
            );
          },
        ),
        BlocProvider<LocationProviderCubit>(
          create: (context) => LocationProviderCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(initState: theme),
        ),
        BlocProvider<PayloadDataPlanCubit>(
          create: (context) => PayloadDataPlanCubit(
            sharedPreferencesRepository,
            // TODO send param in trufiApp
            isDateReset: true,
          ),
          lazy: false,
        ),
        ...providers,
      ],
      child: LocalizedMaterialApp(trufiRoutes: trufiRoutes),
      // child: AppLifecycleReactor(
      //   child: LocalizedMaterialApp(
      //     customHomePage: customHomePage,
      //     routes: routes,
      //     menuItems: menuItems,
      //   ),
      // ),
    );
  }
}

class LocalizedMaterialApp extends StatelessWidget {
  const LocalizedMaterialApp({
    Key key,
    @required this.trufiRoutes,
  }) : super(key: key);

  final RouteMap trufiRoutes;

  @override
  Widget build(BuildContext context) {
    final activeTheme = context.watch<ThemeCubit>().state.activeTheme;
    return MaterialApp.router(
      locale: Locale.fromSubtags(
        languageCode: context.watch<PreferencesCubit>().state.languageCode,
      ),
      localizationsDelegates: const [
        TrufiLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        QuMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: TrufiLocalization.supportedLocales,
      theme: activeTheme ?? ThemeData(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (_) => trufiRoutes),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
