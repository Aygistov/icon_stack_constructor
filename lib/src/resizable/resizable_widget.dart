import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'resizable_widget_controller.dart';
import 'drag_distance.dart';
import 'package:icon_stack_constructor/src/icon_stack/icon_stack.dart';

class ResizableWidget extends StatelessWidget {
  const ResizableWidget({
    Key? key,
    required this.child,
    required this.controller,
    required this.dragWidget,
    required this.dragWidgetHeight,
    required this.dragWidgetWidth,
    required this.iconIndex,
  }) : super(key: key);

  final ResizableWidgetController controller;
  final Widget child;
  final Widget dragWidget;
  final double dragWidgetHeight;
  final double dragWidgetWidth;
  final int iconIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResizableWidgetController>(
      global: false,
      init: controller,
      builder: (controller) {
        return SizedBox.expand(
          child: FractionallySizedBox(
            widthFactor: iconStack.icons[iconIndex].size,
            heightFactor: iconStack.icons[iconIndex].size,
            alignment: FractionalOffset(
                iconStack.icons[iconIndex].x, iconStack.icons[iconIndex].y),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Container(
                height: 100,
                width: 100,
                decoration: iconIndex == currentIconIndex
                    ? BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0),
                      )
                    : BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            width: 0)),
                child: Stack(
                  children: <Widget>[
                    DragDistance(
                      child: child,
                      onDrag: controller.onCenterDrag,
                      onTap: controller.onTap,
                      onDoubleTap: controller.onDoubleTap,
                      iconIndex: iconIndex,
                    ),
                    Visibility(
                      //visible: iconIndex == currentIconIndex,
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          // top left
                          Positioned(
                            left: -dragWidgetHeight / 2,
                            top: -dragWidgetHeight / 2,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpLeft,
                              child: DragDistance(
                                child: dragWidget,
                                onDrag: controller.onTopLeftDrag,
                                onTap: controller.onTap,
                                iconIndex: iconIndex,
                              ),
                            ),
                          ),
                          // top right
                          Positioned(
                            right: -dragWidgetHeight / 2,
                            top: -dragWidgetHeight / 2,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpRight,
                              child: DragDistance(
                                child: dragWidget,
                                onDrag: controller.onTopRightDrag,
                                onTap: controller.onTap,
                                iconIndex: iconIndex,
                              ),
                            ),
                          ),
                          // bottom left
                          Positioned(
                            left: -dragWidgetHeight / 2,
                            bottom: -dragWidgetHeight / 2,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeDownLeft,
                              child: DragDistance(
                                child: dragWidget,
                                onDrag: controller.onBottomLeftDrag,
                                onTap: controller.onTap,
                                iconIndex: iconIndex,
                              ),
                            ),
                          ),
                          // bottom right
                          Positioned(
                            right: -dragWidgetHeight / 2,
                            bottom: -dragWidgetHeight / 2,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeDownRight,
                              child: DragDistance(
                                child: dragWidget,
                                onDrag: controller.onBottomRightDrag,
                                onTap: controller.onTap,
                                iconIndex: iconIndex,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
