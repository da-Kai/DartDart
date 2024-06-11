import 'package:dart_dart/style/font.dart';
import 'package:flutter/material.dart';

class ColorConstants {
  ColorConstants._();

  // #02589b
  static const Color primary = Color.fromRGBO(2, 88, 155, 1.0);
  static const Color primaryLight = Color.fromRGBO(12, 127, 206, 1.0);
  static const Color primaryShade = Color.fromRGBO(1, 63, 126, 1.0);
  static const Color primaryContrast = Color.fromRGBO(62, 119, 189, 1.0);

  // #2cb7f6
  static const Color secondary = Color.fromRGBO(44, 183, 246, 1.0);
  static const Color secondaryLight = Color.fromRGBO(104, 210, 248, 1.0);
  static const Color secondaryShade = Color.fromRGBO(0, 148, 245, 1.0);

  static const Color success = Color.fromRGBO(137, 206, 148, 1.0);
  static const Color warning = Color.fromRGBO(254, 186, 83, 1.0);
  static const Color fault = Color.fromRGBO(224, 122, 95, 1.0);

  static const Color textDark = Color.fromRGBO(57, 47, 45, 1.0);
  static const Color textLight = Color.fromRGBO(251, 246, 236, 1.0);

  static const Color backgroundDark = Color.fromRGBO(33, 33, 33, 1.0);
  static const Color backgroundBeige2 = Color.fromRGBO(185, 168, 138, 1.0);
  static const Color backgroundBeige = Color.fromRGBO(245, 243, 239, 1.0);
  static const Color backgroundLight = Color.fromRGBO(220, 220, 225, 1.0);

  static const Color shadow = Color.fromRGBO(5, 10, 20, 0.8);

  // #272D33
  static const Color primaryContainer = Color.fromRGBO(39, 45, 51, 1.0);

  // #cadeef
  static const Color primaryContainerLight = Color.fromRGBO(221, 212, 198, 1.0);
}

extension ColorSchemes on ColorScheme {
  Color get success {
    return switch(brightness) {
      Brightness.light => ColorConstants.success,
      Brightness.dark => ColorConstants.success
    };
  }

  TextStyle getTextStyle({Color? color, double? fontSize, FontWeight? fontWeight, TextOverflow? overflow}) {
    return FontConstants.text.copyWith(
        color: color ?? onPrimaryContainer, //
        fontSize: fontSize, //
        fontWeight: fontWeight, //
        overflow: overflow);
  }

  Color get backgroundShade {
    return switch(brightness) {
      Brightness.light => ColorConstants.primaryContainerLight,
      Brightness.dark => ColorConstants.primaryContainer
    };
  }

  static const ColorScheme light = ColorScheme.light(
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.textLight,
    secondary: ColorConstants.secondary,
    onSecondary: ColorConstants.textDark,
    error: ColorConstants.fault,
    onError: ColorConstants.textDark,
    errorContainer: ColorConstants.fault,
    onErrorContainer: ColorConstants.textDark,
    primaryContainer: ColorConstants.primary,
    onPrimaryContainer: ColorConstants.textDark,
    shadow: ColorConstants.shadow,
    surface: ColorConstants.backgroundBeige,
  );

  static const ColorScheme dark = ColorScheme.dark(
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.textLight,
    secondary: ColorConstants.secondary,
    onSecondary: ColorConstants.textLight,
    error: ColorConstants.fault,
    onError: ColorConstants.textDark,
    errorContainer: ColorConstants.fault,
    onErrorContainer: ColorConstants.textDark,
    primaryContainer: ColorConstants.primary,
    onPrimaryContainer: ColorConstants.textLight,
    shadow: ColorConstants.shadow,
    surface: ColorConstants.backgroundDark,
    inversePrimary: Colors.yellow,
  );
}
