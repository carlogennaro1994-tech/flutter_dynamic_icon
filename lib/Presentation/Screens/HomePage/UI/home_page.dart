import 'package:flutter_dynamic_icons/flutter_dynamic_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Components/spacer.dart';
import '../../../Declarations/Images/image_files.dart';
import '../../../Declarations/constants.dart';
import '../../../Components/app_bar.dart';
import '../../../Components/primary_btn.dart';
import 'dart:io' show Platform;
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int iconIndex;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        iconIndex = value.getInt('savedIconIndex') ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(appBarTitle: widget.title),
      body: Padding(
          padding: EdgeInsets.all(kSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconTile(0, 'Light'),
              buildIconTile(1, 'Dark'),
              buildIconTile(2, 'Exclusive'),
              HeightSpacer(myHeight: kSpacing),
              PrimaryBtn(btnFun: changeAppIcon, btnText: 'Choose as app Icon'),
            ],
          )),
    );
  }

  Widget buildIconTile(int index, String themeTxt) => Padding(
        padding: EdgeInsets.all(kSpacing / 2),
        child: GestureDetector(
          onTap: () => setState(() => iconIndex = index),
          child: ListTile(
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              leading: Image.asset(
                imagefiles[index],
                width: 45,
                height: 45,
              ),
              title: Text(themeTxt, style: const TextStyle(fontSize: 25)),
              trailing: iconIndex == index
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF6131B4),
                      size: 30,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: Colors.grey[500],
                      size: 30,
                    )),
        ),
      );

  changeAppIcon() async {
    SharedPreferences.getInstance().then((value) {
      value.setInt('savedIconIndex', iconIndex);
    });
    if (Platform.isAndroid) {
      // Android-specific code
      final _flutterDynamicIconsPlugin = FlutterDynamicIcons();
      final List<String> androidIconNames = <String>[
        'icon1',
        'icon2',
        'icon3',
        "MainActivity"
      ];
      _flutterDynamicIconsPlugin.setIcon(
          icon: androidIconNames[iconIndex],
          listAvailableIcon: androidIconNames);
    } else if (Platform.isIOS) {
      // iOS-specific code
      try {
        final List<String> iconName = <String>['icon1', 'icon2', 'icon3'];
        if (await FlutterDynamicIcon.supportsAlternateIcons) {
          await FlutterDynamicIcon.setAlternateIconName(iconName[iconIndex]);
          debugPrint("App icon change successful");
          return;
        }
      } catch (e) {
        debugPrint("Exception: ${e.toString()}");
      }
      debugPrint("Failed to change app icon ");
    }
  }
}
