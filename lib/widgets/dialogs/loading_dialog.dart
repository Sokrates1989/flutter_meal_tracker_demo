// Public package imports
import 'package:flutter/material.dart';

// Custom package imports
import 'package:engaige_meal_tracker_demo/constants/colors.dart';

/// A widget that displays a full-screen loading dialog with a centered
/// `CircularProgressIndicator`. The dialog prevents dismissal unless
/// explicitly closed, providing a visual indicator for ongoing background
/// processes.
///
/// This class is designed to be used for showing and hiding a loading
/// indicator when performing time-consuming tasks (e.g., API calls,
/// database operations).
class LoadingDialog {
  /// Constructor for `LoadingDialog`.
  ///
  /// - [buildContext]: The `BuildContext` of the widget where the dialog
  /// will be displayed.
  LoadingDialog({required this.buildContext});

  /// The `BuildContext` of the parent widget.
  final BuildContext buildContext;

  /// Holds the `BuildContext` of the dialog for managing its dismissal.
  BuildContext? dialogContext;

  /// Displays the loading dialog.
  ///
  /// This method uses `showDialog` to present a `Dialog` with a
  /// `CircularProgressIndicator` at the center. The dialog is
  /// non-dismissible (i.e., cannot be dismissed by tapping outside).
  ///
  /// This method should be called before a long-running task starts.
  void showLoadingDialog() {
    showDialog(
      context: buildContext,
      barrierDismissible: false, // Prevents dismissal by tapping outside.
      builder: (BuildContext context) {
        dialogContext = context; // Capture the context for future dismissal.
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent, // Transparent background.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                color: kColors_primary,
                valueColor: AlwaysStoppedAnimation<Color>(kColors_primary),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Closes the loading dialog.
  ///
  /// This method pops the `Navigator` stack to close the dialog that was
  /// previously shown using [showLoadingDialog]. It should be called once
  /// the long-running task is completed.
  void closeLoadingDialog() {
    if (dialogContext != null) {
      Navigator.pop(dialogContext!);
      dialogContext = null; // Reset after closing
    }
  }
}
