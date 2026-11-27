
import 'package:flutter/material.dart';

enum WindowSize {
  compact,
  medium,
  expanded,
}

class WindowSizeHelper {
  static WindowSize getWindowSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return WindowSize.compact;
    } else if (width < 840) {
      return WindowSize.medium;
    } else {
      return WindowSize.expanded;
    }
  }

  static bool isCompact(BuildContext context) {
    return getWindowSize(context) == WindowSize.compact;
  }

  static bool isMedium(BuildContext context) {
    return getWindowSize(context) == WindowSize.medium;
  }

  static bool isExpanded(BuildContext context) {
    return getWindowSize(context) == WindowSize.expanded;
  }
}
