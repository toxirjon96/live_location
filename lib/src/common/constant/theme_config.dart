import 'package:flutter/material.dart';

import 'app_color.dart';

class ThemeConfig {
  const ThemeConfig._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainColor),
      scaffoldBackgroundColor: AppColor.mainColor,
    );
  }
}
