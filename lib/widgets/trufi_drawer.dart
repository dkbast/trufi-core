import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/menu/menu_item.dart';

class TrufiDrawer extends StatefulWidget {
  const TrufiDrawer(
    this.currentRoute, {
    Key key,
    @required this.menuItems,
    this.backgroundImage = "assets/images/drawer-bg.jpg",
  }) : super(key: key);

  final String currentRoute;
  final List<List<MenuItem>> menuItems;
  final String backgroundImage;
  @override
  TrufiDrawerState createState() => TrufiDrawerState();
}

class TrufiDrawerState extends State<TrufiDrawer> {
  AssetImage bgImage;
  final GlobalKey appShareButtonKey =
      GlobalKey(debugLabel: "appShareButtonKey");

  @override
  void initState() {
    super.initState();
    bgImage = AssetImage(widget.backgroundImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(bgImage, context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);
    final config = context.read<ConfigurationCubit>().state;
    final currentLocale = Localizations.localeOf(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              image: DecorationImage(
                image: bgImage,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(0, 0, 0, 0.5), BlendMode.multiply),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.customTranslations.get(
                              config.customTranslations.title,
                              currentLocale,
                              localization.title,
                            ),
                            style: theme.primaryTextTheme.headline6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            config.customTranslations.get(
                              config.customTranslations.tagline,
                              currentLocale,
                              localization.tagline(config.appCity),
                            ),
                            style: theme.primaryTextTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...widget.menuItems.fold<List<Widget>>(
            [],
            (previousValue, element) => [
              ...previousValue,
              if (previousValue.isNotEmpty) const Divider(),
              ...element.map(
                (element) => element.buildItem(
                  context,
                  isSelected: widget.currentRoute == element.id,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TrufiDrawerRoute<T> extends MaterialPageRoute<T> {
  TrufiDrawerRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class LanguageDropdownValue {
  LanguageDropdownValue(this.languageCode, this.languageString);

  final String languageCode;
  final String languageString;
}
