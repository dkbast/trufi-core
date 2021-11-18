import 'package:flutter/material.dart';
import 'package:trufi_core/base/base_router.dart';
import 'package:trufi_core/services/plan_request/online_repository.dart';
import 'package:trufi_core/trufi_app.dart';
import 'package:trufi_core_example/configuration_service.dart';



void main() {
  // Run app
  runApp(TrufiApp(
    trufiRoutes: buildDefaultRoutes(),
    configuration: setupExampleConfiguration(),
    customRequestManager: OnlineRepository(
      otpEndpoint: "https://api.trufi.app/otp/routers/default",
    ),
  ));
}
