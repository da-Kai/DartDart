import 'package:flutter_test/flutter_test.dart';
import 'package:dart_dart/style/color.dart';

void main() {
  test('Test Color', () {
    var light = ColorSchemes.light;
    var dark = ColorSchemes.dark;

    expect(light.success, ColorConstants.success);
    expect(dark.success, ColorConstants.success);

    expect(light.backgroundShade, ColorConstants.primaryContainerLight);
    expect(dark.backgroundShade, ColorConstants.primaryContainer);
  });
}