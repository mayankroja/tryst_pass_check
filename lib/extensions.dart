import 'package:flutter/material.dart';

extension MediaQueries on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;
}
