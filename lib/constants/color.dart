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

  static Color primary = const Color.fromRGBO(2, 88, 155, 1.0);
  static Color primaryLight = const Color.fromRGBO(12, 127, 206, 1.0);
  static Color primaryShade = const Color.fromRGBO(1, 63, 126, 1.0);
  static Color primaryContrast = const Color.fromRGBO(62, 119, 189, 1.0);

  static Color secondary = const Color.fromRGBO(44, 183, 246, 1.0);
  static Color secondaryLight = const Color.fromRGBO(104, 210, 248, 1.0);
  static Color secondaryShade = const Color.fromRGBO(0, 148, 245, 1.0);

  static Color success = const Color.fromRGBO(137, 206, 148, 1.0);
  static Color warning = const Color.fromRGBO(254, 186, 83, 1.0);
  static Color fault = const Color.fromRGBO(224, 122, 95, 1.0);

  static Color text = const Color.fromRGBO(5, 10, 20, 1.0);
  static Color background = const Color.fromRGBO(240, 240, 250, 1.0);
  static Color shadow = const Color.fromRGBO(5, 10, 20, 0.3);

  static Color unset = const Color.fromRGBO(20, 255, 20, 1.0);
}

class ColorSchemes {
  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.text,
    secondary: ColorConstants.secondary,
    onSecondary: ColorConstants.text,
    tertiary: ColorConstants.secondary,
    onTertiary: ColorConstants.text,
    shadow: ColorConstants.shadow,
    error: ColorConstants.fault,
    onError: ColorConstants.text,
    errorContainer: ColorConstants.fault,
    onErrorContainer: ColorConstants.text,
    background: ColorConstants.background,
    onBackground: ColorConstants.text,
    /* unset values */
    surface: ColorConstants.unset,
    onSurface: ColorConstants.text,
    surfaceVariant: ColorConstants.unset,
    surfaceTint: ColorConstants.unset,
    onSurfaceVariant: ColorConstants.unset,
    outline: ColorConstants.unset,
    outlineVariant: ColorConstants.unset,
    scrim: ColorConstants.unset,
    inverseSurface: ColorConstants.unset,
    onInverseSurface: ColorConstants.unset,
    inversePrimary: ColorConstants.unset,
  );
}