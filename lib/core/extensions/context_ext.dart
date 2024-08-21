import 'package:darts_template_right/core/index.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  AppColorScheme get colorSchema => Theme.of(this).extension<AppColorScheme>()!;

  TextStyle constructStyle({
    Color Function(AppColorScheme)? colorBuilder,
    double? size,
    FontWeight? weight,
  }) {
    return TextStyle(
      color: colorBuilder?.call(colorSchema),
      fontSize: size,
      fontWeight: weight ?? FontWeight.normal,
      fontFamily: "OpenSans",
    );
  }

  void openPageOverlay() {
    // TODO: DEFINE COLORS FOR OVERLAY CHANGES
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: colorSchema.main,
    //     statusBarColor: colorSchema.main,
    //     systemNavigationBarContrastEnforced: true,
    //     systemStatusBarContrastEnforced: true,
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    // );
  }

  void openDialogOverlay() {
    // TODO: DEFINE COLORS FOR OVERLAY CHANGES
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: Color.alphaBlend(
    //       Colors.black54,
    //       colorSchema.main,
    //     ),
    //     statusBarColor: Color.alphaBlend(
    //       Colors.black54,
    //       colorSchema.main,
    //     ),
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    // );
  }

  void closeDialogOverlay() {
    // TODO: DEFINE COLORS FOR OVERLAY CHANGES
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: colorSchema.main,
    //     statusBarColor: colorSchema.main,
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    // );
  }
}
