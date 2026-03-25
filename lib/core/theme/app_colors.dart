import 'package:flutter/material.dart';

enum AppColors {
  blue("blue", Color(0xff6367FF));

  const AppColors(this.name, this.color);

  final String name;
  final Color color;
}
