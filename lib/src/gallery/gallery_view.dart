/* Thanks to font_awesome_flutter and @brianegan for this example gallery
* https://github.com/fluttercommunity/font_awesome_flutter/blob/master/example/lib/main.dart
*/

import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:icon_stack_constructor/src/gallery/icon_lists/all_icons.dart';

const double dragWidgetSize = 30;

class FontAwesomeGalleryApp extends StatefulWidget {
  const FontAwesomeGalleryApp({Key? key}) : super(key: key);

  static const routeName = '/gallery';
  @override
  State<StatefulWidget> createState() => FontAwesomeGalleryHomeState();
}

class FontAwesomeGalleryHomeState extends State<FontAwesomeGalleryApp> {
  var _searchTerm = "";
  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final filteredIcons = allIcons
        .where((icon) =>
            _searchTerm.isEmpty ||
            icon.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: _isSearching ? _searchBar(context) : _titleBar(),
      body: Row(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: filteredIcons.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100),
              itemBuilder: (context, index) {
                final icon = filteredIcons[index];

                return InkWell(
                  onTap: () {
                    Navigator.pop(context, icon.iconData);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                          tag: icon,
                          child: Icon(
                            icon.iconData,
                            //size: 30,
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _titleBar() {
    return AppBar(
      title: const Text("Icon Stack Constructor"),
      actions: [
        IconButton(
            icon: const Icon(Typicons.search),
            onPressed: () {
              ModalRoute.of(context)?.addLocalHistoryEntry(
                LocalHistoryEntry(
                  onRemove: () {
                    setState(() {
                      _searchTerm = "";
                      _isSearching = false;
                    });
                  },
                ),
              );

              setState(() {
                _isSearching = true;
              });
            })
      ],
    );
  }

  AppBar _searchBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Typicons.left_open),
        onPressed: () {
          setState(
            () {
              Navigator.pop(context);
              _isSearching = false;
              _searchTerm = "";
            },
          );
        },
      ),
      title: TextField(
        onChanged: (text) => setState(() => _searchTerm = text),
        autofocus: true,
        style: const TextStyle(fontSize: 18.0),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
