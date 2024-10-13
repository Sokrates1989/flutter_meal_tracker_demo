// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:flutter/cupertino.dart';

/// Wraps values for widget sizes when retrieving responsive ui.
class WidgetSizeValues {
  WidgetSizeValues({this.padding, this.size});

  EdgeInsetsGeometry? padding;
  double? size;
}
