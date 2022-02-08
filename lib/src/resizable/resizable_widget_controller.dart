import 'dart:math';

import 'package:flutter/cupertino.dart';
//import 'package:get/get.dart';
import 'package:icon_stack_constructor/src/icon_stack/icon_stack.dart';
import 'package:icon_stack_constructor/src/icon_stack/icon_stack_view.dart';

import '../color_picker/material_color_picker.dart';

class ResizableWidgetController {
  static const _minSize = 0.05;
  double _a(double x, double s) {
    return x * s;
  }

  double _b(double x, double ax) {
    return x == 0 ? _scale() : ax / x - ax;
  }

  double _newSize(double size, double dx, double dy) {
    return max(0, min(1, size - (dx + dy) / 2 / _stackHeight()));
  }

  double _newA(double x, double scale, double dx, double dy) {
    final ax = _a(x, scale);
    final bx = _b(x, ax);
    return max(0, min(1, (ax + (dx + dy) / 2) / (ax + (dx + dy) / 2 + bx)));
  }

  double _newB(double x, double scale, double dx, double dy) {
    final ax = _a(x, scale);
    final bx = _b(x, ax);
    return max(0, min(1, (ax / (ax + (dx + dy) / 2 + bx))));
  }

  double _stackHeight() {
    final box = iconStackKey.currentContext?.findRenderObject() as RenderBox;
    return box.size.height;
  }

  double _scale() {
    return _stackHeight() *
        (1 - iconStack.icons[iconStack.currentIconIndex].size);
  }

  void onTopLeftDrag(dx, dy) {
    if (iconStack.icons[iconStack.currentIconIndex].x == 0 && dx + dy < 0) {
      return;
    }
    if (iconStack.icons[iconStack.currentIconIndex].y == 0 && dx + dy < 0) {
      return;
    }

    final _newSizeValue =
        _newSize(iconStack.icons[iconStack.currentIconIndex].size, dx, dy);
    if (_newSizeValue < _minSize) {
      return;
    }

    final scale = _scale();
    iconStack.icons[iconStack.currentIconIndex].size = _newSizeValue;
    iconStack.icons[iconStack.currentIconIndex].x =
        _newA(iconStack.icons[iconStack.currentIconIndex].x, scale, dx, dy);
    iconStack.icons[iconStack.currentIconIndex].y =
        _newA(iconStack.icons[iconStack.currentIconIndex].y, scale, dx, dy);
    iconStack.notify();
  }

  void onTopRightDrag(dx, dy) {
    if (iconStack.icons[iconStack.currentIconIndex].x == 1 && -dx + dy < 0) {
      return;
    }
    if (iconStack.icons[iconStack.currentIconIndex].y == 0 && -dx + dy < 0) {
      return;
    }
    final _newSizeValue =
        _newSize(iconStack.icons[iconStack.currentIconIndex].size, -dx, dy);
    if (_newSizeValue < _minSize) {
      return;
    }
    final scale = _scale();
    iconStack.icons[iconStack.currentIconIndex].size = _newSizeValue;

    iconStack.icons[iconStack.currentIconIndex].x =
        _newB(iconStack.icons[iconStack.currentIconIndex].x, scale, -dx, dy);
    iconStack.icons[iconStack.currentIconIndex].y =
        _newA(iconStack.icons[iconStack.currentIconIndex].y, scale, -dx, dy);
    iconStack.notify();
  }

  void onCenterDrag(dx, dy) {
    final scale = _scale();
    if (scale == 0) {
      return;
    }
    iconStack.icons[iconStack.currentIconIndex].x = max(
        0, min(1, iconStack.icons[iconStack.currentIconIndex].x + dx / scale));
    iconStack.icons[iconStack.currentIconIndex].y = max(
        0, min(1, iconStack.icons[iconStack.currentIconIndex].y + dy / scale));
    iconStack.notify();
  }

  void onBottomLeftDrag(dx, dy) {
    if (iconStack.icons[iconStack.currentIconIndex].x == 0 && dx - dy < 0) {
      return;
    }
    if (iconStack.icons[iconStack.currentIconIndex].y == 1 && dx - dy < 0) {
      return;
    }
    final _newSizeValue =
        _newSize(iconStack.icons[iconStack.currentIconIndex].size, dx, -dy);
    if (_newSizeValue < _minSize) {
      return;
    }
    final scale = _scale();
    iconStack.icons[iconStack.currentIconIndex].size = _newSizeValue;
    iconStack.icons[iconStack.currentIconIndex].x =
        _newA(iconStack.icons[iconStack.currentIconIndex].x, scale, dx, -dy);
    iconStack.icons[iconStack.currentIconIndex].y =
        _newB(iconStack.icons[iconStack.currentIconIndex].y, scale, dx, -dy);
    iconStack.notify();
  }

  void onBottomRightDrag(dx, dy) {
    if (iconStack.icons[iconStack.currentIconIndex].x == 1 && -dx - dy < 0) {
      return;
    }
    if (iconStack.icons[iconStack.currentIconIndex].y == 1 && -dx - dy < 0) {
      return;
    }
    final _newSizeValue =
        _newSize(iconStack.icons[iconStack.currentIconIndex].size, -dx, -dy);
    if (_newSizeValue < _minSize) {
      return;
    }
    final scale = _scale();
    iconStack.icons[iconStack.currentIconIndex].size = _newSizeValue;

    iconStack.icons[iconStack.currentIconIndex].x =
        _newB(iconStack.icons[iconStack.currentIconIndex].x, scale, -dx, -dy);
    iconStack.icons[iconStack.currentIconIndex].y =
        _newB(iconStack.icons[iconStack.currentIconIndex].y, scale, -dx, -dy);
    iconStack.notify();
  }

  void onTap() {
    iconStack.notify();
    colorPickerNotifier.notify();
  }

  void onDoubleTap() {
    if (iconStack.icons[iconStack.currentIconIndex].size == 1) {
      iconStack.icons[iconStack.currentIconIndex].size = 0.1;
    } else {
      iconStack.icons[iconStack.currentIconIndex].size = 1;
    }
    iconStack.notify();
  }
}
