import 'package:flutter/material.dart';

class PortView {

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }


  static double sumBannerSize(double viewSize) {
    if (viewSize > 800.0) {
      return 90.0;
    }

    else if (viewSize > 400.0) {
      return 70.0;
    }

    else {
      return 50.0;
    }
  }


  static double regularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 18.0;
    }

    else if (viewSize > 400.0) {
      return 14.0;
    }

    else {
      return 12.0;
    }
  }

  static double biggerRegularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 21.0;
    }

    else if (viewSize > 400.0) {
      return 18.0;
    }

    else {
      return 14.0;
    }
  }

  static double doubleRegularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 32.0;
    }

    else if (viewSize > 400.0) {
      return 28.0;
    }

    else {
      return 24.0;
    }
  }
}