import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CustomTheme extends Equatable {
  final ThemeData activeTheme;
  final ThemeData searchTheme;
  final ThemeData bottomBarTheme;

  CustomTheme({
    ThemeData activeTheme,
    ThemeData searchTheme,
    ThemeData bottomBarTheme,
  })  : activeTheme = activeTheme ?? ThemeData(),
        searchTheme = searchTheme ??
            getDefaultSearchTheme(
              activeTheme ?? ThemeData(),
            ),
        bottomBarTheme = bottomBarTheme ??
            getDefaultBottomBarTheme(
              activeTheme ?? ThemeData(),
            );
  static ThemeData getDefaultSearchTheme(
    ThemeData activeTheme,
  ) {
    return activeTheme.copyWith(
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
      primaryIconTheme:
          activeTheme.primaryIconTheme.copyWith(color: Colors.black54),
      textTheme: activeTheme.primaryTextTheme.copyWith(
        headline6: activeTheme.primaryTextTheme.bodyText2
            .copyWith(color: Colors.black),
        bodyText2: activeTheme.primaryTextTheme.bodyText2
            .copyWith(color: Colors.black),
        bodyText1: activeTheme.primaryTextTheme.bodyText1.copyWith(
          color: activeTheme.accentColor,
        ),
      ),
    );
  }

  static ThemeData getDefaultBottomBarTheme(ThemeData activeTheme) {
    return activeTheme.copyWith(
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
      primaryIconTheme:
          activeTheme.primaryIconTheme.copyWith(color: Colors.black54),
      textTheme: activeTheme.primaryTextTheme.copyWith(
        headline6: activeTheme.primaryTextTheme.bodyText2
            .copyWith(color: Colors.black),
        bodyText2: activeTheme.primaryTextTheme.bodyText2
            .copyWith(color: Colors.black),
        bodyText1: activeTheme.primaryTextTheme.bodyText1.copyWith(
          color: activeTheme.accentColor,
        ),
      ),
    );
  }

  @override
  List<Object> get props => [activeTheme, searchTheme, bottomBarTheme];

  @override
  String toString() =>
      "ThemeState: {activeTheme $activeTheme, searchTheme $searchTheme}, bottomBarTheme $bottomBarTheme}";
}
