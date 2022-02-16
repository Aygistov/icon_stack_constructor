import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import '../color_picker/material_color_picker.dart';
import 'package:icon_stack_constructor/src/gallery/gallery_view.dart';
import '../settings/settings_view.dart';
import 'package:icon_stack_constructor/src/resizable/resizable_widget_controller.dart';
import 'package:icon_stack_constructor/src/resizable/resizable_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'icon_stack.dart';

GlobalKey iconStackKey = GlobalKey();

class IconStackView extends StatefulWidget {
  const IconStackView({
    Key? key,
    required this.currentIconStack,
  }) : super(key: key);

  static const routeName = '/icon_stack';
  final IconStack currentIconStack;

  @override
  State<IconStackView> createState() => _IconStackViewState();
}

class _IconStackViewState extends State<IconStackView> {
  bool _buttonPressed = false;
  bool _loopActive = false;

  //final List<SampleItem> items;
  @override
  Widget build(BuildContext context) {
    iconStack = widget.currentIconStack;

    return ChangeNotifierProvider.value(
      value: iconStack,
      child: Scaffold(
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Add icon',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              Tooltip(
                message: 'Delete icon',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    _deleteIcon(context);
                  },
                  child: const Icon(Icons.delete),
                ),
              ),
              Tooltip(
                message: 'Z-index +',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    _upIcon(context);
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
              Tooltip(
                message: 'Z-index -',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    _downIcon(context);
                  },
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
              Listener(
                onPointerDown: (details) {
                  //_rotateLeftIcon();
                  _buttonPressed = true;
                  _rotateLeftWhilePressed();
                },
                onPointerUp: (details) {
                  _buttonPressed = false;
                },
                child: Tooltip(
                  message: 'Rotate left',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      _rotateLeftIcon(0.01);
                    },
                    child: const Icon(Icons.rotate_left),
                  ),
                ),
              ),
              Listener(
                onPointerDown: (details) {
                  _buttonPressed = true;
                  _rotateRightWhilePressed();
                },
                onPointerUp: (details) {
                  _buttonPressed = false;
                },
                child: Tooltip(
                  message: 'Rotate right',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      _rotateRightIcon(0.01);
                    },
                    child: const Icon(Icons.rotate_right),
                  ),
                ),
              ),
              Tooltip(
                message: 'Flip',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    _flipIcon(context);
                  },
                  child: const Icon(Octicons.mirror),
                ),
              ),
            ],
          ),
        ],
        appBar: AppBar(
          title: const Text('Icon Stack Constructor'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap,
                child: IconStackWidget(
                  iconStack,
                  key: iconStackKey,
                ),
              ),
              Column(
                children: [
                  MaterialColorPicker(
                    circleSize: 30,
                    onColorChange: (Color color) {
                      if (iconStack.currentIconIndex != -1) {
                        iconStack.icons[iconStack.currentIconIndex].color =
                            color;
                        iconStack.notify();
                      }
                    },
                    onMainColorChange: (ColorSwatch? color) {
                      // Handle main color changes
                    },
                  ),
                  IconStackResultWidget(iconStack),
                  Expanded(child: IconStackCodeWidget(iconStack)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (iconStack.currentIconIndex != -1) {
      iconStack.currentIconIndex = -1;

      iconStack.notify();
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FontAwesomeGalleryApp()),
    );

    if (result != null) {
      final iconStruct = result;
      iconStack.icons.add(
        PositionedIcon(
          icon: iconStruct['iconData'],
          name: iconStruct['name'],
          family: iconStruct['family'],
          size: 0.1,
          x: Random().nextDouble(),
          y: Random().nextDouble(),
          color: Colors
              .primaries[Random().nextInt(Colors.primaries.length)].shade500,
        ),
      );
      iconStack.currentIconIndex = iconStack.icons.length - 1;
      iconStack.notify();
    }
  }

  void _rotateLeftWhilePressed() async {
    if (_loopActive) return; // check if loop is active

    _loopActive = true;
    await Future.delayed(const Duration(milliseconds: 100));
    while (_buttonPressed) {
      _rotateLeftIcon(0.05);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _loopActive = false;
  }

  void _rotateRightWhilePressed() async {
    if (_loopActive) return; // check if loop is active

    _loopActive = true;
    await Future.delayed(const Duration(milliseconds: 100));
    while (_buttonPressed) {
      _rotateRightIcon(0.05);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _loopActive = false;
  }
}

void _deleteIcon(BuildContext context) {
  if (iconStack.currentIconIndex != -1) {
    iconStack.icons.removeAt(iconStack.currentIconIndex);
    iconStack.currentIconIndex = -1;
    iconStack.notify();
  }
}

void _upIcon(BuildContext context) {
  if (iconStack.currentIconIndex != -1 &&
      iconStack.currentIconIndex < iconStack.icons.length - 1) {
    iconStack.icons
        .move(iconStack.currentIconIndex, iconStack.currentIconIndex + 1);
    iconStack.currentIconIndex = iconStack.currentIconIndex + 1;
    iconStack.notify();
  }
}

void _downIcon(BuildContext context) {
  if (iconStack.currentIconIndex > 0) {
    iconStack.icons
        .move(iconStack.currentIconIndex, iconStack.currentIconIndex - 1);
    iconStack.currentIconIndex = iconStack.currentIconIndex - 1;

    iconStack.notify();
  }
}

void _flipIcon(BuildContext context) {
  if (iconStack.currentIconIndex >= 0) {
    iconStack.icons[iconStack.currentIconIndex].flip =
        !iconStack.icons[iconStack.currentIconIndex].flip;

    iconStack.notify();
  }
}

double roundDouble(double value, int places) {
  var mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

void _rotateLeftIcon(double step) {
  if (iconStack.currentIconIndex != -1) {
    final angle =
        (iconStack.icons[iconStack.currentIconIndex].angle - step) % (2 * pi);
    iconStack.icons[iconStack.currentIconIndex].angle =
        roundDouble(angle > pi ? angle - 2 * pi : angle, 2);
    iconStack.notify();
  }
}

void _rotateRightIcon(double step) {
  if (iconStack.currentIconIndex != -1) {
    final angle =
        (iconStack.icons[iconStack.currentIconIndex].angle + step) % (2 * pi);
    iconStack.icons[iconStack.currentIconIndex].angle =
        roundDouble(angle > pi ? angle - 2 * pi : angle, 2);
    iconStack.notify();
  }
}

extension MoveElement<T> on List<T> {
  void move(int from, int to) {
    RangeError.checkValidIndex(from, this, "from", length);
    RangeError.checkValidIndex(to, this, "to", length);
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}

IconData? icon;
const double dragWidgetSize = 30;

class IconStackWidget extends StatelessWidget {
  final IconStack iconStack;

  const IconStackWidget(
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconStackIcons = context.watch<IconStack>().icons;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Stack(
            children: iconStackIcons
                .asMap()
                .entries
                .map((entry) =>
                    PositionedIconWidget(entry.value, entry.key, iconStack))
                .toList()),
      ),
    );
  }
}

class IconStackResultWidget extends StatelessWidget {
  final IconStack iconStack;

  const IconStackResultWidget(
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconStackIcons = context.watch<IconStack>().icons;

    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
          children: iconStackIcons
              .asMap()
              .entries
              .map((entry) =>
                  PositionedIconResultWidget(entry.value, entry.key, iconStack))
              .toList()),
    );
  }
}

class IconStackCodeWidget extends StatelessWidget {
  final IconStack iconStack;

  const IconStackCodeWidget(
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconStack = context.watch<IconStack>();
    final double width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.height +
        120;

    return Column(
      children: [
        Expanded(
          //flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            width: width,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SelectableText(
                      iconStack.packages(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Tooltip(
                    message: 'Copy packages import code to clipboard',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: iconStack.packages()));
                      },
                      child: const Icon(Icons.copy),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          //flex: 10,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            width: width,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SelectableText(
                      iconStack.toString(),
                      //maxLines: 20,
                      //expands: true,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Tooltip(
                    message: 'Copy Icon Stack code to clipboard',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: iconStack.toString()));
                      },
                      child: const Icon(Icons.copy),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PositionedIconResultWidget extends StatelessWidget {
  final IconStack iconStack;
  final PositionedIcon positionedIcon;
  final int iconIndex;

  PositionedIconResultWidget(
    this.positionedIcon,
    this.iconIndex,
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  final controller = ResizableWidgetController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: FractionallySizedBox(
        widthFactor: iconStack.icons[iconIndex].size,
        heightFactor: iconStack.icons[iconIndex].size,
        alignment: FractionalOffset(
            iconStack.icons[iconIndex].x, iconStack.icons[iconIndex].y),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Transform.rotate(
            angle: positionedIcon.angle,
            child: Transform(
              transform: Matrix4.rotationY(positionedIcon.flip ? pi : 0),
              alignment: Alignment.center,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Icon(
                  positionedIcon.icon,
                  color: positionedIcon.color,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PositionedIconWidget extends StatelessWidget {
  final IconStack iconStack;
  final PositionedIcon positionedIcon;
  final int iconIndex;

  PositionedIconWidget(
    this.positionedIcon,
    this.iconIndex,
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  final controller = ResizableWidgetController();

  @override
  Widget build(BuildContext context) {
    return ResizableWidget(
      iconIndex: iconIndex,
      dragWidgetHeight: dragWidgetSize,
      dragWidgetWidth: dragWidgetSize,
      controller: controller,
      dragWidget: const SizedBox(
        height: dragWidgetSize,
        width: dragWidgetSize,
      ),
      child: Transform.rotate(
        angle: positionedIcon.angle,
        child: Transform(
          transform: Matrix4.rotationY(positionedIcon.flip ? pi : 0),
          alignment: Alignment.center,
          child: Icon(
            positionedIcon.icon,
            color: positionedIcon.color,
            size: 100,
          ),
        ),
      ),
    );
  }
}
