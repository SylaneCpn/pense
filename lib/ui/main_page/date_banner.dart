import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/elevated_container.dart';
import 'package:pense/ui/utils/gradient_title.dart';
import 'package:provider/provider.dart';

class DateBanner extends StatelessWidget {
  final double height;
  final Month month;
  final int year;
  final void Function()? prevMonthCallback;
  final void Function()? nextMonthCallback;
  final void Function(Month, int)? setDateCallBack;

  const DateBanner({
    super.key,
    required this.height,
    required this.month,
    required this.year,
    this.prevMonthCallback,
    this.nextMonthCallback,
    this.setDateCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final color = appState.onLightBackgroundColor();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedContainer(
        decoration: BoxDecoration(
          color: appState.lessContrastBackgroundColor(),
        ),
        borderRadius: BorderRadius.circular(24.0),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: prevMonthCallback,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: prevMonthCallback != null ? color : null,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => DateSelector(
                      setDateCallBack: setDateCallBack,
                      initMonth: month,
                      initYear: year,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientTitle(label: month.toStringFr()),

                        GradientTitle(label: year.toString()),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: nextMonthCallback,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: nextMonthCallback != null ? color : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
