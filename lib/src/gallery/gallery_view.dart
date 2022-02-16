import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:icon_stack_constructor/src/gallery/icon_lists/all_icons.dart';

const double dragWidgetSize = 30;
var familys = <String, bool>{};
var allFamilys = true;

class FontAwesomeGalleryApp extends StatefulWidget {
  FontAwesomeGalleryApp({Key? key}) : super(key: key) {
    for (var icon in allIcons) {
      familys.putIfAbsent(icon.family, () => true);
    }
  }

  static const routeName = '/gallery';
  @override
  State<StatefulWidget> createState() => FontAwesomeGalleryHomeState();
}

class FontAwesomeGalleryHomeState extends State<FontAwesomeGalleryApp> {
  var _searchTerm = "";
  var _isSearching = true;

  @override
  Widget build(BuildContext context) {
    final filteredIcons = allIcons
        .where((icon) =>
            (_searchTerm.isEmpty ||
                icon.name.toLowerCase().contains(_searchTerm.toLowerCase())) &&
            familys[icon.family] == true)
        .toList();

    return Scaffold(
      appBar: _isSearching ? _searchBar(context) : _titleBar(),
      body: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                color: Color.fromARGB(255, 226, 226, 226),
                width: 1,
              )),
            ),
            height: double.infinity,
            width: 200,
            child: ListView(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CheckboxListTile(
                    activeColor: Theme.of(context).colorScheme.primary,
                    dense: true,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                    title: const Text('All'),
                    value: allFamilys,
                    onChanged: (newValue) {
                      familys.forEach((key, value) {
                        familys[key] = newValue!;
                      });
                      allFamilys = newValue!;
                      setState(() {});
                    },
                  ),
                  const Divider(),
                  ...familys.entries
                      .map(
                        (entry) => CheckboxListTile(
                          activeColor: Theme.of(context).colorScheme.primary,
                          dense: true,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1),
                          title: Text(entry.key),
                          subtitle: Text(fontsInfo[entry.key] == null
                              ? ''
                              : ('by ' +
                                  fontsInfo[entry.key]!['author']! +
                                  '\nlicense: ' +
                                  fontsInfo[entry.key]!['license']!)),
                          value: familys[entry.key],
                          onChanged: (newValue) {
                            familys[entry.key] = newValue!;
                            if (newValue == false && allFamilys) {
                              allFamilys = false;
                            }
                            setState(() {});
                          },
                        ),
                      )
                      .toList(),
                ]),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: filteredIcons.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100),
              itemBuilder: (context, index) {
                final icon = filteredIcons[index];

                return Tooltip(
                  waitDuration: const Duration(milliseconds: 1000),
                  message: '${icon.family}\n${icon.name}',
                  child: InkWell(
                    onTap: () {
                      var iconStruct = {
                        'iconData': icon.iconData,
                        'family': icon.family,
                        'name': icon.name
                      };
                      Navigator.pop(context, iconStruct);
                    },
                    child: Icon(
                      icon.iconData,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
      title: Row(
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              onChanged: (text) => setState(() => _searchTerm = text),
              autofocus: true,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onPrimary),
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 30,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary)),
                hintText: 'Search',
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const fontsInfo = {
  'Iconic': {
    'package': 'fluttericon/iconic_icons.dart',
    'license': 'SIL',
    'author': 'P.J.Onori',
  },
  'Linecons': {
    'package': 'fluttericon/linecons_icons.dart',
    'license': 'CC BY',
    'author': 'Designmodo for Smashing Magazine',
  },
  'MfgLabs': {
    'package': 'fluttericon/mfg_labs_icons.dart',
    'license': 'SIL',
    'author': 'MFG Labs',
  },
  'Octicons': {
    'package': 'fluttericon/octicons_icons.dart',
    'license': 'MIT',
    'author': 'GitHub',
  },
  'FontAwesome': {
    'package': 'fluttericon/font_awesome_icons.dart',
    'license': 'SIL',
    'author': 'Dave Gandy',
  },
  'FontAwesome5': {
    'package': 'fluttericon/font_awesome5_icons.dart',
    'license': 'SIL',
    'author': 'Dave Gandy',
  },
  'Entypo': {
    'package': 'fluttericon/entypo_icons.dart',
    'license': 'SIL',
    'author': 'Daniel Bruce',
  },
  'LineariconsFree': {
    'package': 'fluttericon/linearicons_free_icons.dart',
    'license': 'CC BY-SA 4.0',
    'author': 'Perxis',
  },
  'Maki': {
    'package': 'fluttericon/maki_icons.dart',
    'license': 'BSD',
    'author': 'Mapbox',
  },
  'Meteocons': {
    'package': 'fluttericon/meteocons_icons.dart',
    'license': 'SIL',
    'author': 'Alessio Atzeni',
  },
  'RpgAwesome': {
    'package': 'fluttericon/rpg_awesome_icons.dart',
    'license': 'SIL',
    'author': 'Daniel Howe & Ivan Montiel',
  },
  'Brandico': {
    'package': 'fluttericon/brandico_icons.dart',
    'license': 'SIL',
    'author': 'Crowdsourced, for Fontello project',
  },
  'Fontelico': {
    'package': 'fluttericon/fontelico_icons.dart',
    'license': 'SIL',
    'author': 'Crowsourced',
  },
  'Typicons': {
    'package': 'fluttericon/typicons_icons.dart',
    'license': 'SIL',
    'author': 'Stephen Hutchings',
  },
  'Zocial': {
    'package': 'fluttericon/zocial_icons.dart',
    'license': 'MIT',
    'author': 'Sam Collins',
  },
  'ModernPictograms': {
    'package': 'fluttericon/modern_pictograms_icons.dart',
    'license': 'SIL',
    'author': 'John Caserta',
  },
  'Elusive': {
    'package': 'fluttericon/elusive_icons.dart',
    'license': 'SIL',
    'author': 'Aristeides Stathopoulos',
  },
  'WebSymbols': {
    'package': 'fluttericon/web_symbols_icons.dart',
    'license': 'SIL',
    'author': 'Just Be Nice studio',
  },
};
