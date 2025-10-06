import 'package:flutter/material.dart';
import 'package:pense/logic/app_state.dart';
import 'package:pense/logic/month.dart';
import 'package:provider/provider.dart';

class DateBanner extends StatelessWidget {

  final double height;
  final Month month;
  final int year;
  final void Function()? prevMonthCallback;
  final void Function()? nextMonthCallback;

  const DateBanner({super.key , required this.height , required this.month , required this.year , this.prevMonthCallback , this.nextMonthCallback});

  @override
  Widget build(BuildContext context) {

    final appState = context.read<AppState>();
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Container(
        decoration: BoxDecoration( color: appState.primaryContainer(context),borderRadius: BorderRadius.circular(8.0)),
         child: SizedBox(
          height: height,
           child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: prevMonthCallback, icon: Icon(Icons.arrow_back_ios , color: appState.onPrimaryContainer(context),)),
              ),
               Expanded(
                 child: Align(
                  alignment: Alignment.center,
                   child: Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                     children: [
                       Text(
                         style: TextStyle(
                          fontSize: 28.0,
                          color: appState.onPrimaryContainer(context)),
                         month.toStringFr()),

                         Text(
                         style: TextStyle(
                          fontSize: 14.0,
                          color: appState.onPrimaryContainer(context)),
                         year.toString() ),
                     ],
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: IconButton(onPressed: nextMonthCallback, icon: Icon(Icons.arrow_forward_ios , color : appState.onPrimaryContainer(context))),
               ),
             ],
           ),
         ),
       ),
     );
  }
}