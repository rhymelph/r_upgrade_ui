import 'package:flutter/material.dart';
import 'package:r_upgrade_ui/r_upgrade_info.dart';
import 'package:r_upgrade_ui/r_upgrade_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RUpgrade UI Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RUpgradeInfo rUpgradeInfo = RUpgradeInfo()
    ..androidInfo = (RUpgradeAndroidInfo()
      ..webUrl = 'http://www.baidu.com'
      ..downloadUrl =
          'https://mydata-1252536312.cos.ap-guangzhou.myqcloud.com/r_upgrade.apk'
      ..downloadFileName = 'r_upgrade.apk'
      ..downloadFinishAutoInstall = true
      ..downloadUseCache = false
      ..upgradeFlavor = RUpgradeFlavor.normal
      ..notificationVisibility = NotificationVisibility.VISIBILITY_VISIBLE
      ..notificationStyle = NotificationStyle.planTime)
    ..iosInfo = (RUpgradeIOSInfo()
      ..webUrl = 'http://www.google.com'
      ..isChina = false
      ..appId = '414478124')
    ..isForce = true
    ..newVersion = 'v1.0.1'
    ..newVersionCode = 1
    ..content = '1.fixed bug,\n2.fixed bug again'
    ..title = 'New Version';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              rUpgradeInfo.showNormalDialog(context);

            },
            title: const Text('Normal Style'),
            trailing: Icon(Icons.arrow_right_outlined),
          )
        ],
      ),
    );
  }
}
