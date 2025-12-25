import 'package:flutter/material.dart';

abstract final class PortView {
  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double sumBannerSize(double viewSize) {
    if (viewSize > 800.0) {
      return 90.0;
    } else if (viewSize > 400.0) {
      return 70.0;
    } else {
      return 50.0;
    }
  }

  static double sumSmallBannerSize(double viewSize) {
    if (viewSize > 800.0) {
      return 80.0;
    } else if (viewSize > 400.0) {
      return 65.0;
    } else {
      return 42.0;
    }
  }

  static double regularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 18.0;
    } else if (viewSize > 360.0) {
      return 14.0;
    } else {
      return 10.0;
    }
  }

  static double slightlyBiggerRegularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 20.0;
    } else if (viewSize > 400.0) {
      return 16.0;
    } else {
      return 12.0;
    }
  }

  static double biggerRegularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 22.0;
    } else if (viewSize > 400.0) {
      return 18.0;
    } else {
      return 13.0;
    }
  }

  static double doubleRegularTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 32.0;
    } else if (viewSize > 400.0) {
      return 28.0;
    } else {
      return 20.0;
    }
  }

  static double mediumTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 24.0;
    } else if (viewSize > 400.0) {
      return 21.0;
    } else {
      return 15.0;
    }
  }


  static double bigTextSize(double viewSize) {
    if (viewSize > 800.0) {
      return 28.0;
    } else if (viewSize > 400.0) {
      return 25.0;
    } else {
      return 17.0;
    }
  }
}
