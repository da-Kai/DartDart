import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  /* hex color must be #rrggbb or #rrggbbaa */
  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  ColorConstants._();

  static const Color primary = Color.fromRGBO(2, 88, 155, 1.0);
  static const Color primaryLight = Color.fromRGBO(12, 127, 206, 1.0);
  static const Color primaryShade = Color.fromRGBO(1, 63, 126, 1.0);
  static const Color primaryContrast = Color.fromRGBO(62, 119, 189, 1.0);

  static const Color secondary = Color.fromRGBO(44, 183, 246, 1.0);
  static const Color secondaryLight = Color.fromRGBO(104, 210, 248, 1.0);
  static const Color secondaryShade = Color.fromRGBO(0, 148, 245, 1.0);

  static const Color success = Color.fromRGBO(137, 206, 148, 1.0);
  static const Color warning = Color.fromRGBO(254, 186, 83, 1.0);
  static const Color fault = Color.fromRGBO(224, 122, 95, 1.0);

  static const Color text = Color.fromRGBO(5, 10, 20, 1.0);
  static const Color background = Color.fromRGBO(240, 240, 250, 1.0);
  static const Color shadow = Color.fromRGBO(5, 10, 20, 0.3);
}

class ColorSchemes {
  static const ColorScheme light = ColorScheme.light(
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.text,
    secondary: ColorConstants.secondary,
    onSecondary: ColorConstants.text,
    tertiary: ColorConstants.secondary,
    onTertiary: ColorConstants.text,
    error: ColorConstants.fault,
    onError: ColorConstants.text,
    errorContainer: ColorConstants.fault,
    onErrorContainer: ColorConstants.text,
    //background: ColorConstants.background,
    //onBackground: ColorConstants.text,
  );

  static const ColorScheme dark = ColorScheme.dark(
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.text,
    secondary: ColorConstants.secondary,
    onSecondary: ColorConstants.text,
    tertiary: ColorConstants.secondary,
    onTertiary: ColorConstants.text,
    error: ColorConstants.fault,
    onError: ColorConstants.text,
    errorContainer: ColorConstants.fault,
    onErrorContainer: ColorConstants.text,
  );
}
