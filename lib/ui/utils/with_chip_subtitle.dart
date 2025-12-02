import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/utils.dart';
import 'package:pense/ui/utils/gradient_chip.dart';
import 'package:pense/ui/utils/port_view.dart';
import 'package:pense/ui/utils/with_title.dart';
import 'package:provider/provider.dart';

class WithChipSubtitle extends StatelessWidget {
  final String subtitle;
  final Widget child;
  const WithChipSubtitle({
    super.key,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final chipColor = appState.primaryColor(context);
    return WithTitle(
      leading: GradientChip(
        start: chipColor,
        end: gradientPairColor(chipColor),
        width: 4.0,
        height: PortView.bigTextSize(MediaQuery.widthOf(context)),
        borderRadius: 4.0,
      ),
      titlePadding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
      title: Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: Text(
          style: TextStyle(
            color: appState.onLightBackgroundColor(),
            fontSize: PortView.mediumTextSize(MediaQuery.widthOf(context)),
          ),
          subtitle,
        ),
      ),
      child: child,
    );
  }
}
