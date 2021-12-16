import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';
import 'package:trufi_core/blocs/custom_layer/custom_layers_cubit.dart';
import 'package:trufi_core/blocs/gps_location/location_provider_cubit.dart';
import 'package:trufi_core/blocs/map_tile_provider/map_tile_provider_cubit.dart';

import 'trufi_map_controller.dart';

typedef LayerOptionsBuilder = List<LayerOptions> Function(BuildContext context);

class TrufiMap extends StatefulWidget {
  const TrufiMap({
    Key? key,
    required this.controller,
    required this.layerOptionsBuilder,
    this.onTap,
    this.onLongPress,
    this.onPositionChanged,
    this.showCustomMarkes = true,
  }) : super(key: key);

  final TrufiMapController controller;
  final LayerOptionsBuilder layerOptionsBuilder;
  final TapCallback? onTap;
  final LongPressCallback? onLongPress;
  final PositionCallback? onPositionChanged;
  final bool showCustomMarkes;
  @override
  _TrufiMapState createState() => _TrufiMapState();
}

class _TrufiMapState extends State<TrufiMap> {
  int? mapZoom;

  @override
  Widget build(BuildContext context) {
    final Configuration cfg = context.read<ConfigurationCubit>().state;
    final MapTileProviderState currentMapType = context.watch<MapTileProviderCubit>().state;
    final currentLocation =
        context.watch<LocationProviderCubit>().state.currentLocation;
    final customLayersCubit = context.watch<CustomLayersCubit>();
    return FlutterMap(
      mapController: widget.controller.mapController,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.drag |
            InteractiveFlag.flingAnimation |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.doubleTapZoom,
        minZoom: cfg.map!.onlineMinZoom,
        maxZoom: cfg.map!.onlineMaxZoom,
        zoom: cfg.map!.onlineZoom,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        center: cfg.map!.center,
        onPositionChanged: (
          MapPosition position,
          bool hasGesture,
        ) {
          if (widget.onPositionChanged != null) {
            Future.delayed(Duration.zero, () {
              widget.onPositionChanged!(position, hasGesture);
            });
          }
          // fix render issue
          Future.delayed(Duration.zero, () {
            final int zoom = position.zoom!.round();
            if (mapZoom != zoom) setState(() => mapZoom = zoom);
          });
        },
      ),
      layers: [
        ...currentMapType.currentMapTileProvider!.buildTileLayerOptions(),
        if (widget.showCustomMarkes)
          ...customLayersCubit.activeCustomLayers(mapZoom).reversed,
        cfg.map!.markersConfiguration
            .buildYourLocationMarkerLayerOptions(currentLocation),
        ...widget.layerOptionsBuilder(context)
      ],
    );
  }
}
