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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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

  late AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 15));

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
            trailing: const Icon(Icons.arrow_right_outlined),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: AbsorbCustomPainter(
                      0.2, controller.value, 2, Colors.orange),
                  size: const Size(0, 30),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.forward(from: 0.0);
  }
}

class AbsorbCustomPainter extends CustomPainter {
  final double speed;
  final double progress;
  final double total;
  final Color color;

  AbsorbCustomPainter(this.speed, this.progress, this.total, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
            const Radius.circular(8)),
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * (progress / total), size.height),
            const Radius.circular(8)),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
