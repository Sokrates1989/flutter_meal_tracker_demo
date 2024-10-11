import 'package:flutter/cupertino.dart';

/// Wraps values for widget sizes when retrieving responsive ui.
class WidgetSizeValues {
  WidgetSizeValues({this.padding, this.size});

  EdgeInsetsGeometry? padding;
  double? size;
}
