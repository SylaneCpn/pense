import 'package:flutter/material.dart';
import 'package:pense/ui/utils/port_view.dart';

class Actions extends StatelessWidget {
  final List<String> actions;
  final List<void Function()> actionsCallBacks;
  const Actions({
    super.key,
    required this.actions,
    required this.actionsCallBacks,
  });

  @override
  Widget build(BuildContext context) {
    assert(actions.length == actionsCallBacks.length);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List<Widget>.generate(
        actions.length,
        (index) => Flexible(
          child: FittedBox(
            child: TextButton(
              onPressed: actionsCallBacks[index],
              child: Text(
                style: TextStyle(
                  fontSize: PortView.regularTextSize(
                    MediaQuery.widthOf(context),
                  ),
                ),
                actions[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
