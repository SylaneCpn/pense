import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/currency.dart';
import 'package:pense/ui/options_page/color_circle.dart';
import 'package:pense/ui/options_page/selection_radio.dart';
import 'package:pense/ui/options_page/switch_label.dart';
import 'package:pense/ui/utils/decorated_gradient_title.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  TextStyle _selectionTextStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.slightlyBiggerRegularTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: DecoratedGradientTitle(
              innerPadding: const EdgeInsets.all(12.0),
              label: "Options",
            ),
          ),
          OptionSection(
            sectionName: "Theme",
            children: [
              SwitchLabel(
                label: "Utiliser la luminosité système",
                toWatchFlag: appState.useSystemBrightness,
                toogleToWatchFlagCallback: appState.toggleUseSystemBrighness,
              ),
              SwitchLabel(
                label: "Mode sombre",
                toWatchFlag: appState.isDark,
                toogleToWatchFlagCallback: appState.toggleTheme,
                disabled: appState.useSystemBrightness,
              ),
            ],
          ),
          OptionSection(
            sectionName: "Couleurs",
            children: [
              SwitchLabel(
                label: "Couleurs Système",
                toWatchFlag: appState.trySystemColors,
                toogleToWatchFlagCallback: appState.toggleDynamicColors,
                disabled: !appState.canUseSystemColors,
              ),

              SelectionRadio(
                label: "Couleur de l'app",
                selectedElementIndex: appState.colorIndex,
                setIndexCallBack: appState.setColorIndex,
                disabled: appState.trySystemColors,
                widgetFromElement: (element) => Row(
                  spacing: 8.0,
                  children: [
                    ColorCircle(color: element),
                    Expanded(child: Text(element.toStringFr() , style: _selectionTextStyle(appState, context),))
                  ],
                ),
                elements: AppState.colors,
              ),
            ],
          ),

          OptionSection(
            sectionName: "Divers",
            children: [
              SelectionRadio(
                label: "Devise",
                selectedElementIndex: appState.currencyIndex,
                setIndexCallBack: appState.setCurrencyIndex,
                widgetFromElement: (element) => Text("${element.toStringFr()} (${element.symbol()})" ,style: _selectionTextStyle(appState, context),),
                elements: Currency.values,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionSection extends StatelessWidget {
  final List<Widget> children;
  final String sectionName;
  final double spacing;
  const OptionSection({
    super.key,
    required this.sectionName,
    this.spacing = 8.0,
    this.children = const <Widget>[],
  });

  TextStyle _sectionNameStyle(AppState appState, BuildContext context) {
    return TextStyle(
      color: appState.onLessContrastBackgroundColor(),
      fontSize: PortView.bigTextSize(MediaQuery.widthOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35.0, top: 20.0),
          child: Text(sectionName, style: _sectionNameStyle(appState, context)),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth * 0.75,
                child: Column(children: children),
              ),
            );
          },
        ),
      ],
    );
  }
}
