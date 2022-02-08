import 'package:flutter/material.dart';
import 'package:icon_stack_constructor/src/icon_stack/icon_stack.dart';

class DragDistance extends StatefulWidget {
  const DragDistance({
    Key? key,
    required this.onDrag,
    required this.onTap,
    this.onDoubleTap,
    required this.child,
    required this.iconIndex,
  }) : super(key: key);

  final Function(double dx, double dy) onDrag;
  final Function() onTap;
  final Function()? onDoubleTap;

  final Widget child;
  final int iconIndex;

  @override
  State<DragDistance> createState() => _DragDistanceState();
}

class _DragDistanceState extends State<DragDistance> {
  double initX = 0;
  double initY = 0;

  void _handleDrag(DragStartDetails details) {
    iconStack.currentIconIndex = widget.iconIndex;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
  }

  void _handleTap() {
    iconStack.currentIconIndex = widget.iconIndex;
    widget.onTap();
    iconStack.notify();
  }

  void _handleDoubleTap() {
    iconStack.currentIconIndex = widget.iconIndex;
    widget.onDoubleTap!();
  }

  void _handleUpdate(DragUpdateDetails details) {
    double dx = details.globalPosition.dx - initX;
    double dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: widget.child,
    );
  }
}
