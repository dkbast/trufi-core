import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trufi_core/models/definition_feedback.dart';
import 'package:trufi_core/models/menu/menu_item.dart';
import 'package:trufi_core/models/menu/social_media/facebook_social_media.dart';
import 'package:trufi_core/models/menu/social_media/instagram_social_media.dart';
import 'package:trufi_core/models/menu/social_media/twitter_social_media.dart';
import 'package:trufi_core/models/menu/social_media/website_social_media.dart';
import 'package:trufi_core/pages/about.dart';
import 'package:trufi_core/pages/feedback.dart';
import 'package:trufi_core/pages/home/home_page.dart';
import 'package:trufi_core/pages/saved_places/saved_places.dart';

RouteMap buildDefaultRoutes({List<List<MenuItem>> menuItems}) {
  final List<List<MenuItem>> defaultItems = [
    ...defaultMenuItems,
    [
      FacebookSocialMedia("https://www.facebook.com/trufiapp"),
      InstagramSocialMedia("https://www.instagram.com/trufi.app"),
      TwitterSocialMedia("https://twitter.com/TrufiAssoc"),
      WebSiteSocialMedia("https://www.trufi.app/blog/"),
    ]
  ];
  menuItems ??= defaultItems;
  final routes = RouteMap(
    onUnknownRoute: (_) => const Redirect(HomePage.route),
    routes: {
      HomePage.route: (_) => MaterialPage(
            child: HomePage(menuItems: menuItems),
          ),
      SavedPlacesPage.route: (_) => MaterialPage(
            child: SavedPlacesPage(menuItems: menuItems),
          ),
      AboutPage.route: (_) => MaterialPage(
            child: AboutPage(menuItems: menuItems),
          ),
      FeedbackPage.route: (_) => MaterialPage(
            child: FeedbackPage(
              menuItems: menuItems,
              feedBack: FeedbackDefinition(
                FeedBackType.email,
                "info@trufi.app",
              ),
            ),
          ),
    },
  );
  return routes;
}
