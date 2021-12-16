import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';
import 'package:trufi_core/blocs/home_page_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/enums/server_type.dart';
import 'package:trufi_core/models/map_route_state.dart';

import '../../models/trufi_place.dart';
import 'home_buttons.dart';
import 'search_location/location_form_field.dart';
import 'setting_payload/setting_payload.dart';
import 'transport_selector/transport_selector.dart';

class FormFieldsPortrait extends StatelessWidget {
  const FormFieldsPortrait({
    Key? key,
    required this.onSaveFrom,
    required this.onSaveTo,
    required this.onFetchPlan,
    required this.onReset,
    required this.onSwap,
  }) : super(key: key);

  final void Function(TrufiLocation) onSaveFrom;
  final void Function(TrufiLocation) onSaveTo;
  final void Function() onFetchPlan;
  final void Function() onReset;
  final void Function() onSwap;

  @override
  Widget build(BuildContext context) {
    final translations = TrufiLocalization.of(context);
    final MapRouteState homePageState = context.read<HomePageCubit>().state;
    final Configuration config = context.read<ConfigurationCubit>().state;
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LocationFormField(
                  isOrigin: true,
                  onSaved: onSaveFrom,
                  hintText: translations.searchPleaseSelectOrigin,
                  textLeadingImage: config.map!.markersConfiguration.fromMarker,
                  leading: const SizedBox.shrink(),
                  trailing: homePageState.isPlacesDefined
                      ? ResetButton(onReset: onReset)
                      : null,
                  value: homePageState.fromPlace,
                ),
                LocationFormField(
                  isOrigin: false,
                  onSaved: onSaveTo,
                  hintText: translations.searchPleaseSelectDestination,
                  textLeadingImage: config.map!.markersConfiguration.toMarker,
                  leading: const SizedBox.shrink(),
                  trailing: homePageState.isPlacesDefined
                      ? SwapButton(
                          orientation: Orientation.portrait,
                          onSwap: onSwap,
                        )
                      : null,
                  value: homePageState.toPlace,
                ),
                if (config.serverType == ServerType.graphQLServer)
                  SettingPayload(onFetchPlan: onFetchPlan),
              ],
            ),
          ),
          const TransportSelector(),
        ],
      ),
    );
  }
}
