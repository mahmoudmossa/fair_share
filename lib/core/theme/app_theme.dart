import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006948),
      surfaceTint: Color(0xff006c4a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00855d),
      onPrimaryContainer: Color(0xfff5fff7),
      secondary: Color(0xff9d4300),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff97316),
      onSecondaryContainer: Color(0xff582200),
      tertiary: Color(0xff5451a9),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6c6ac4),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fbf5),
      onSurface: Color(0xff171d19),
      onSurfaceVariant: Color(0xff3d4a42),
      outline: Color(0xff6d7a72),
      outlineVariant: Color(0xffbccac0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff68dba9),
      primaryFixed: Color(0xff85f8c4),
      onPrimaryFixed: Color(0xff002114),
      primaryFixedDim: Color(0xff68dba9),
      onPrimaryFixedVariant: Color(0xff005137),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff783200),
      tertiaryFixed: Color(0xffe2dfff),
      onTertiaryFixed: Color(0xff0f0168),
      tertiaryFixedDim: Color(0xffc3c0ff),
      onTertiaryFixedVariant: Color(0xff3e3b92),
      surfaceDim: Color(0xffd5dcd6),
      surfaceBright: Color(0xfff5fbf5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5ef),
      surfaceContainer: Color(0xffe9efe9),
      surfaceContainerHigh: Color(0xffe4eae4),
      surfaceContainerHighest: Color(0xffdee4de),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f2a),
      surfaceTint: Color(0xff006c4a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff007d56),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5e2500),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb54e00),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2d2981),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6563bc),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf5),
      onSurface: Color(0xff0d120f),
      onSurfaceVariant: Color(0xff2d3932),
      outline: Color(0xff49554e),
      outlineVariant: Color(0xff637068),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff68dba9),
      primaryFixed: Color(0xff007d56),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006143),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffb54e00),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff8e3c00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6563bc),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4c4aa2),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c8c2),
      surfaceBright: Color(0xfff5fbf5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5ef),
      surfaceContainer: Color(0xffe4eae4),
      surfaceContainerHigh: Color(0xffd8ded8),
      surfaceContainerHighest: Color(0xffcdd3cd),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003321),
      surfaceTint: Color(0xff006c4a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005439),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4e1e00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7c3300),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff221d77),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff403e95),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf5),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff232f28),
      outlineVariant: Color(0xff404c45),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff68dba9),
      primaryFixed: Color(0xff005439),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b27),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7c3300),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff582300),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff403e95),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff29257d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4bab5),
      surfaceBright: Color(0xfff5fbf5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2ec),
      surfaceContainer: Color(0xffdee4de),
      surfaceContainerHigh: Color(0xffd0d6d0),
      surfaceContainerHighest: Color(0xffc2c8c2),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff68dba9),
      surfaceTint: Color(0xff68dba9),
      onPrimary: Color(0xff003825),
      primaryContainer: Color(0xff25a475),
      onPrimaryContainer: Color(0xff002114),
      secondary: Color(0xffffb690),
      onSecondary: Color(0xff552100),
      secondaryContainer: Color(0xfff97316),
      onSecondaryContainer: Color(0xff582200),
      tertiary: Color(0xffc3c0ff),
      onTertiary: Color(0xff27227b),
      tertiaryContainer: Color(0xff8987e3),
      onTertiaryContainer: Color(0xff100368),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffdee4de),
      onSurfaceVariant: Color(0xffbccac0),
      outline: Color(0xff87948b),
      outlineVariant: Color(0xff3d4a42),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff006c4a),
      primaryFixed: Color(0xff85f8c4),
      onPrimaryFixed: Color(0xff002114),
      primaryFixedDim: Color(0xff68dba9),
      onPrimaryFixedVariant: Color(0xff005137),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff783200),
      tertiaryFixed: Color(0xffe2dfff),
      onTertiaryFixed: Color(0xff0f0168),
      tertiaryFixedDim: Color(0xffc3c0ff),
      onTertiaryFixedVariant: Color(0xff3e3b92),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff343b37),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff252b28),
      surfaceContainerHighest: Color(0xff303632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff7ff2be),
      surfaceTint: Color(0xff68dba9),
      onPrimary: Color(0xff002c1c),
      primaryContainer: Color(0xff25a475),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd3be),
      onSecondary: Color(0xff441900),
      secondaryContainer: Color(0xfff97316),
      onSecondaryContainer: Color(0xff180500),
      tertiary: Color(0xffdbd8ff),
      onTertiary: Color(0xff1b1470),
      tertiaryContainer: Color(0xff8987e3),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd2e0d6),
      outline: Color(0xffa8b5ac),
      outlineVariant: Color(0xff86938b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff005338),
      primaryFixed: Color(0xff85f8c4),
      onPrimaryFixed: Color(0xff00150b),
      primaryFixedDim: Color(0xff68dba9),
      onPrimaryFixedVariant: Color(0xff003f2a),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff230900),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff5e2500),
      tertiaryFixed: Color(0xffe2dfff),
      onTertiaryFixed: Color(0xff07004c),
      tertiaryFixedDim: Color(0xffc3c0ff),
      onTertiaryFixedVariant: Color(0xff2d2981),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff404642),
      surfaceContainerLowest: Color(0xff040806),
      surfaceContainerLow: Color(0xff191f1b),
      surfaceContainer: Color(0xff232925),
      surfaceContainerHigh: Color(0xff2e3430),
      surfaceContainerHighest: Color(0xff393f3b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbaffdb),
      surfaceTint: Color(0xff68dba9),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff64d7a5),
      onPrimaryContainer: Color(0xff000e07),
      secondary: Color(0xffffece4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb087),
      onSecondaryContainer: Color(0xff1a0600),
      tertiary: Color(0xfff1eeff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbebcff),
      onTertiaryContainer: Color(0xff04003b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe6f3e9),
      outlineVariant: Color(0xffb8c6bc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff005338),
      primaryFixed: Color(0xff85f8c4),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff68dba9),
      onPrimaryFixedVariant: Color(0xff00150b),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff230900),
      tertiaryFixed: Color(0xffe2dfff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc3c0ff),
      onTertiaryFixedVariant: Color(0xff07004c),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff4b524d),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b211d),
      surfaceContainer: Color(0xff2c322e),
      surfaceContainerHigh: Color(0xff373d39),
      surfaceContainerHighest: Color(0xff424844),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xffe8319d),
    value: Color(0xffe8319d),
    light: ColorFamily(
      color: Color(0xffb10074),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd82090),
      onColorContainer: Color(0xfffffbff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xffb10074),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd82090),
      onColorContainer: Color(0xfffffbff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xffb10074),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd82090),
      onColorContainer: Color(0xfffffbff),
    ),
    dark: ColorFamily(
      color: Color(0xffffafd2),
      onColor: Color(0xff63003f),
      colorContainer: Color(0xfffd44ae),
      onColorContainer: Color(0xff370021),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffafd2),
      onColor: Color(0xff63003f),
      colorContainer: Color(0xfffd44ae),
      onColorContainer: Color(0xff370021),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffafd2),
      onColor: Color(0xff63003f),
      colorContainer: Color(0xfffd44ae),
      onColorContainer: Color(0xff370021),
    ),
  );

  List<ExtendedColor> get extendedColors => [customColor1];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
