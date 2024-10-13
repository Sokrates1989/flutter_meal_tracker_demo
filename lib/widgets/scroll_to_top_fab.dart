// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:flutter/material.dart';

// Custom package imports
import 'package:engaige_meal_tracker_demo/constants/colors.dart';

class ScrollToTopFloatingActionButton extends StatelessWidget {
  ScrollToTopFloatingActionButton({super.key, 
    required this.showScrollToTopBtn,
    required this.scrollController,
    this.additionalOnClick,
  });

  Function? additionalOnClick;
  bool showScrollToTopBtn;
  ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      //show/hide animation
      opacity: showScrollToTopBtn ? 1.0 : 0.0,
      //set opacity to 1 on visible, or hide
      child: FloatingActionButton(
        onPressed: () {

          // Scroll to top.
          scrollController.animateTo(
            //go to top of scroll
              0, //scroll offset to go
              duration: Duration(milliseconds: 500), //duration of scroll
              curve: Curves.fastOutSlowIn //scroll type
          );

          // Execute additional custom on click function.
          if (additionalOnClick != null) {
            additionalOnClick!();
          }
        },
        backgroundColor: kColors_scrollToTopFloatingActionButton_backgroundColor,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

}

