import 'package:flutter/material.dart';

import '../gallery/gallery_view.dart';
import 'package:hive/hive.dart';
// ignore: unused_import
//import 'package:hive_generator/hive_generator.dart';

part 'icon_stack.g.dart';

late IconStackList iconStackList;

IconStack iconStack = IconStack([]);

@HiveType(typeId: 0)
class PositionedIcon extends HiveObject {
  @HiveField(0)
  final IconData icon;

  @HiveField(1)
  final String? family;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  double size;

  @HiveField(4)
  double x;

  @HiveField(5)
  double y;

  @HiveField(6)
  double angle;

  @HiveField(7)
  Color? color;

  @HiveField(8, defaultValue: false)
  bool flip;

  PositionedIcon({
    required this.icon,
    required this.size,
    required this.x,
    required this.y,
    this.family,
    this.name,
    this.color,
    this.angle = 0,
    this.flip = false,
  });

  @override
  String toString() {
    final _size = size.toStringAsFixed(3);
    final _x = x.toStringAsFixed(3);
    final _y = y.toStringAsFixed(3);
    final _name = '$family.$name';
    final _angle = angle.toStringAsFixed(2);

    return '  PositionedIcon(icon: $_name, size: $_size, x: $_x, y: $_y, color: const $color' +
        (angle == 0 ? '' : ', angle: $_angle') +
        (flip == true ? ', flip: $flip' : '') +
        ')';
  }
}

@HiveType(typeId: 1)
class IconStack extends ChangeNotifier {
  @HiveField(0)
  int currentIconIndex = -1;

  @HiveField(1)
  final List<PositionedIcon> icons;

  @HiveField(2)
  IconStack(this.icons);

  void notify() {
    notifyListeners();
    iconStackList.save();
  }

  @override
  String toString() {
    var iconsString = '';
    for (var element in icons) {
      iconsString = iconsString + element.toString() + ',\n';
    }
    return 'IconStack([\n' + iconsString + ']);';
  }

  String packages() {
    var packageString = '';
    var packages = '';
    var packagesList = <String>[];

    for (var element in icons) {
      if (element.icon.fontPackage != null &&
          element.icon.fontFamily != null &&
          fontsInfo[element.icon.fontFamily!] != null) {
        packageString = 'import \'package:' +
            fontsInfo[element.icon.fontFamily!]!['package']! +
            '\';\n';
      }
      if (!packagesList.contains(packageString)) {
        packagesList.add(packageString);
      }
    }

    for (var element in packagesList) {
      packages = packages + element;
    }
    return packages;
  }

  String dependences() {
    var dependences = '';

    for (var element in icons) {
      if (element.icon.fontFamily != 'MaterialIcons') {
        dependences = 'dependencies: \n  fluttericon: ^2.0.0';
        return dependences;
      }
    }
    return dependences;
  }
}

@HiveType(typeId: 2)
class IconStackList extends HiveObject {
  @HiveField(0)
  final List<IconStack> iconStacks;
  IconStackList(this.iconStacks);
}

initAppData() async {
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(IconDataAdapter());
  Hive.registerAdapter(PositionedIconAdapter());
  Hive.registerAdapter(IconStackAdapter());
  Hive.registerAdapter(IconStackListAdapter());

  await getAppData();
}

getAppData() async {
  var iconStackListBox = await Hive.openBox<IconStackList>('iconStackList');
  final iconStackListData = iconStackListBox.get('iconStackList');
  if (iconStackListData != null) {
    iconStackList = iconStackListData;
  } else {
    iconStackList = IconStackList([]);
    iconStackListBox.put('iconStackList', iconStackList);
  }
}

class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 3;

  @override
  IconData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconData(
      fields[0] as int,
      fontFamily: fields[1] as String?,
      fontPackage: fields[2] as String?,
      matchTextDirection: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.codePoint)
      ..writeByte(1)
      ..write(obj.fontFamily)
      ..writeByte(2)
      ..write(obj.fontPackage)
      ..writeByte(3)
      ..write(obj.matchTextDirection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionedIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 4;

  @override
  Color read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Color(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionedIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
