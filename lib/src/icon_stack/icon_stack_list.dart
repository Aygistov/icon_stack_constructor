import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import '../settings/settings_view.dart';
import 'icon_stack.dart';
import 'icon_stack_view.dart';
import 'package:dotted_border/dotted_border.dart';

class IconStackListView extends StatefulWidget {
  const IconStackListView({
    Key? key,
    this.items = const [],
  }) : super(key: key);

  static const routeName = '/';

  final List<IconStack> items;

  @override
  State<IconStackListView> createState() => _IconStackListViewState();
}

class _IconStackListViewState extends State<IconStackListView> {
  @override
  Widget build(BuildContext context) {
    //final currentIconIndex = context.watch<IconStack>().currentIconIndex;

    const double itemSize = 150;
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
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          itemCount: iconStackList.iconStacks.length + 1,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: itemSize,
          ),
          itemBuilder: (context, index) {
            if (index < iconStackList.iconStacks.length) {
              final currentIconStack = iconStackList.iconStacks[index];

              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    _awaitReturn(context, currentIconStack);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: itemSize - 70,
                            width: itemSize - 70,
                            child: IconStackWidget(currentIconStack),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ElevatedButton(
                            onPressed: () {
                              iconStackList.iconStacks.remove(currentIconStack);
                              iconStackList.save();
                              setState(() {});
                            },
                            child: const Text('Delete')),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(6),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(7),
                  strokeCap: StrokeCap.round,
                  color: Theme.of(context).colorScheme.primary,
                  dashPattern: const [4, 4],
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    child: InkWell(
                      onTap: () {
                        iconStackList.iconStacks.add(IconStack([]));
                        iconStackList.save();
                        _awaitReturn(context, iconStackList.iconStacks.last);
                      },
                      child: Align(
                        child: Icon(
                          Icons.add,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _awaitReturn(BuildContext context, IconStack currentIconStack) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IconStackView(
            currentIconStack: currentIconStack,
          ),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {});
  }
}

class IconStackWidget extends StatelessWidget {
  final IconStack iconStack;

  const IconStackWidget(
    this.iconStack, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
          children: iconStack.icons
              .asMap()
              .entries
              .map((entry) =>
                  PositionedIconResultWidget(entry.value, entry.key, iconStack))
              .toList()),
    );
  }
}
