import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:pense/ui/utils/date_selector.dart';
import 'package:pense/ui/utils/port_view.dart';
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
      child: Container(
        decoration: BoxDecoration(
          color: appState.primaryContainer(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
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
                        Text(
                          style: TextStyle(
                            fontSize: PortView.doubleRegularTextSize(
                              MediaQuery.sizeOf(context).width,
                            ),
                            color: color,
                          ),
                          month.toStringFr(),
                        ),

                        Text(
                          style: TextStyle(
                            fontSize: PortView.regularTextSize(
                              MediaQuery.sizeOf(context).width,
                            ),
                            color: color,
                          ),
                          year.toString(),
                        ),
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
