import 'dart:math';

import 'package:flutter/material.dart';
import 'package:icon_stack_constructor/src/gallery/gallery_view.dart';
import '../settings/settings_view.dart';
//import 'icon_stack.dart';
import 'package:get/get.dart';
import 'package:icon_stack_constructor/src/resizable/resizable_widget_controller.dart';
import 'package:icon_stack_constructor/src/resizable/resizable_widget.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        tooltip: 'Add icon',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Row(
            children: [
              IconStackWidget(
                iconStack,
                key: iconStackKey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (currentIconIndex != -1) {
      currentIconIndex = -1;
      setState(() {});
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
      currentIconIndex = iconStack.icons.length - 1;
      setState(() {});
    }
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
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Stack(
            children: iconStack.icons
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

  final controller = Get.put(
    ResizableWidgetController(),
  );

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
