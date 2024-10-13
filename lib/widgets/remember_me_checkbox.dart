// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// A custom widget that provides a "Remember Me" checkbox with a clickable
/// label and icon. The checkbox is wrapped in an `InkWell` to make the
/// entire row (including the label) tappable, enhancing the user experience.
///
/// The state of the checkbox (checked/unchecked) is controlled by the
/// `isChecked` property, and any changes trigger the `onChanged` callback.
class RememberMeCheckbox extends StatelessWidget {
  /// Indicates whether the checkbox is checked.
  final bool isChecked;

  /// Callback that is triggered when the checkbox is toggled.
  ///
  /// The callback receives the new state of the checkbox (true for checked,
  /// false for unchecked).
  final ValueChanged<bool> onChanged;

  /// Creates a `RememberMeCheckbox` widget.
  ///
  /// - [isChecked] controls the state of the checkbox.
  /// - [onChanged] is called when the checkbox is toggled.
  const RememberMeCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        // Taps toggle the checkbox value.
        onTap: () => onChanged(!isChecked),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Checkbox is displayed but doesn't handle changes directly,
            // as it is controlled by the `onChanged` callback.
            Checkbox(
              value: isChecked,
              onChanged: (_) {}, // No direct interaction with the checkbox.
            ),
            // Label for the checkbox, localized using easy_localization.
            Text(tr('Remember Me')),
          ],
        ),
      ),
    );
  }
}
