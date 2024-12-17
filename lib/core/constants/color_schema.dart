import 'package:flutter/material.dart';

/// Color scheme (Using Flutter ThemeExtensions) - for simpler color access (and different color schemes). Modify for the exact color scheme of the app.
class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  Color main;
  Color bg;

  CustomColorScheme({
    required this.main,
    required this.bg,
  });

  @override
  ThemeExtension<CustomColorScheme> lerp(
      covariant ThemeExtension<CustomColorScheme>? other, double t) {
    if (other is! CustomColorScheme) {
      return this;
    }
    return CustomColorScheme(
      bg: Color.lerp(bg, other.bg, t) ?? bg,
      main: Color.lerp(main, other.main, t) ?? main,
    );
  }

  @override
  CustomColorScheme copyWith({
    Color? main,
    Color? bg,
  }) {
    return CustomColorScheme(
      main: main ?? this.main,
      bg: bg ?? this.bg,
    );
  }
}

class CustomThemeDatas {
  static ThemeData get light => ThemeData(
        extensions: [
          CustomColorScheme(
            main: const Color(0xFFFFFFFF),
            bg: const Color(0xFFF0F0F0),
          ),
        ],
      );

  // static ThemeData get dark => ThemeData(
  //       extensions: [
  //         WashdColorScheme(),
  //       ],
  //     ); // TODO: UNCOMMENT IF DARK THEME IS NEEDED
}
