import 'dart:math';

import 'package:flutter/material.dart';
import '../color_picker/material_color_picker.dart';
import 'package:icon_stack_constructor/src/gallery/gallery_view.dart';
import '../settings/settings_view.dart';
<<<<<<< HEAD
=======
import 'package:get/get.dart';
>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
import 'package:icon_stack_constructor/src/resizable/resizable_widget_controller.dart';
import 'package:icon_stack_constructor/src/resizable/resizable_widget.dart';
import 'package:provider/provider.dart';

import 'icon_stack.dart';

GlobalKey iconStackKey = GlobalKey();

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  //final List<SampleItem> items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
              tooltip: 'Add icon',
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _deleteIcon(context);
              },
              tooltip: 'Delete icon',
              child: const Icon(Icons.delete),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _upIcon(context);
              },
              tooltip: 'Up',
              child: const Icon(Icons.upcoming),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _downIcon(context);
              },
              tooltip: 'Down',
              child: const Icon(Icons.downhill_skiing),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            ChangeNotifierProvider.value(
              value: iconStack,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap,
                child: IconStackWidget(
                  iconStack,
                  key: iconStackKey,
                ),
              ),
            ),
            Column(
              children: [
<<<<<<< HEAD
                ChangeNotifierProvider.value(
                  value: iconStack,
                  child: ChangeNotifierProvider.value(
                    value: colorPickerNotifier,
                    child: MaterialColorPicker(
                      circleSize: 30,
                      onColorChange: (Color color) {
                        if (iconStack.currentIconIndex != -1) {
                          iconStack.icons[iconStack.currentIconIndex].color =
                              color;
                          iconStack.notify();
                          //setState(() {});
                        }
                      },
                      onMainColorChange: (ColorSwatch? color) {
                        // Handle main color changes
                      },
                      /*
                      selectedColor: iconStack.currentIconIndex == -1
                          ? null
                          : context.watch<IconStack>().currentIconColor;
                          */
                    ),
                  ),
=======
                MaterialColorPicker(
                  circleSize: 30,
                  onColorChange: (Color color) {
                    if (currentIconIndex >= 0) {
                      iconStack.icons[currentIconIndex].color = color;
                      iconStack.notify();
                      //setState(() {});
                    }
                  },
                  onMainColorChange: (ColorSwatch? color) {
                    // Handle main color changes
                  },
                  //selectedColor: ,
>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onTap() {
<<<<<<< HEAD
    if (iconStack.currentIconIndex != -1) {
      iconStack.currentIconIndex = -1;

=======
    if (currentIconIndex != -1) {
      currentIconIndex = -1;
>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
      iconStack.notify();
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FontAwesomeGalleryApp()),
    );

    if (result != null) {
      icon = result;
      iconStack.icons.add(
        PositionedIcon(
          icon: icon!,
          size: 0.1,
          x: Random().nextDouble(),
          y: Random().nextDouble(),
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        ),
      );
<<<<<<< HEAD
      iconStack.currentIconIndex = iconStack.icons.length - 1;
      iconStack.notify();
    }
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
  if (iconStack.currentIconIndex != -1) {
    iconStack.icons
        .move(iconStack.currentIconIndex, iconStack.currentIconIndex + 1);
    iconStack.currentIconIndex = iconStack.currentIconIndex + 1;
    iconStack.notify();
  }
}

void _downIcon(BuildContext context) {
  if (iconStack.currentIconIndex != -1) {
    iconStack.icons
        .move(iconStack.currentIconIndex, iconStack.currentIconIndex - 1);
    iconStack.currentIconIndex = iconStack.currentIconIndex - 1;

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
=======
      currentIconIndex = iconStack.icons.length - 1;
      iconStack.notify();
>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
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
      child: Icon(
        positionedIcon.icon,
        color: positionedIcon.color,
        size: 100,
      ),
    );
  }
}
