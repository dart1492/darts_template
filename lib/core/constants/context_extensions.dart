import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_schema.dart';

/// Extensions for the BuildContext class of Flutter library. Contains some useful functionality:
/// - Color shcheme access;
/// - UI system overlay control
extension ContextExt on BuildContext {
  CustomColorScheme get colorSchema =>
      Theme.of(this).extension<CustomColorScheme>()!;

  // TODO: SIMPLE TEXT STYLING CONSTRUCTOR (CAN BE CUSTOMIZED)
  // TextStyle constructStyle({
  //   Color Function(CustomColorScheme)? colorBuilder,
  //   double? size,
  //   FontWeight? weight,
  // }) {
  //   return TextStyle(
  //     color: colorBuilder?.call(colorSchema) ?? colorSchema.text.base,
  //     fontSize: size,
  //     fontWeight: weight ?? FontWeight.normal,
  //     fontFamily: GeneralConstants.fontFamily,
  //   );
  // }

  // USED TO CHANGE THE SYSTEM UI OVERLAY WHEN PUSHING A NEW PAGE ON TOP OF THE STACK (CUSTOMIZE COLORS TO YOUR OWN NEEDS)
  void openPageOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorSchema.main,
        statusBarColor: colorSchema.main,
        systemNavigationBarContrastEnforced: true,
        systemStatusBarContrastEnforced: true,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // USED TO CHANGE THE SYSTEM UI OVERLAY WHEN OPENING A DIALOG (CUSTOMIZE COLORS TO YOUR OWN NEEDS)
  void openDialogOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color.alphaBlend(
          Colors.black54,
          colorSchema.main,
        ),
        statusBarColor: Color.alphaBlend(
          Colors.black54,
          colorSchema.main,
        ),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // USED TO CHANGE THE SYSTEM UI OVERLAY WHEN CLOSING A DIALOG (CUSTOMIZE COLORS TO YOUR OWN NEEDS)
  void closeDialogOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorSchema.main,
        statusBarColor: colorSchema.main,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
