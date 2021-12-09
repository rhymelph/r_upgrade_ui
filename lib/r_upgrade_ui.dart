library r_upgrade_ui;

export 'r_upgrade_info.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:r_upgrade/r_upgrade.dart';

import 'r_upgrade_info.dart';

const _kAnimationDuration = 300;

class RUpgradeNormalDialog extends StatefulWidget {
  final RUpgradeInfo info;

  const RUpgradeNormalDialog({Key? key, required this.info}) : super(key: key);

  @override
  _RUpgradeNormalDialogState createState() => _RUpgradeNormalDialogState();
}

class _RUpgradeNormalDialogState extends State<RUpgradeNormalDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  bool enterNewStatus = false;
  bool enterNewStatus2 = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _kAnimationDuration));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: _kAnimationDuration),
          width: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: enterNewStatus
              ? _buildAndroidUpgradeProgress(context)
              : _buildUpgradeContent(context),
        ),
      ),
    );
  }

  Widget _buildAndroidUpgradeProgress(BuildContext context) =>
      AnimatedContainer(
        duration: Duration(milliseconds: _kAnimationDuration),
        height: enterNewStatus2 ? 120 : 250,
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 16,
              child: FadeTransition(
                opacity: _controller,
                child: StreamBuilder(
                  stream: widget.info.androidInfo.downloadStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DownloadInfo> snapshot) {
                    String status = 'Unknow';
                    if (snapshot.hasData) {
                      if (snapshot.data!.status ==
                          DownloadStatus.STATUS_SUCCESSFUL) {
                        status = 'Donwload Finish';
                        _controller.reverse();
                      } else if (snapshot.data!.status ==
                          DownloadStatus.STATUS_FAILED) {
                        status = 'Donwload Failed';
                      } else if (snapshot.data!.status ==
                          DownloadStatus.STATUS_CANCEL) {
                        status = 'Donwload Canceled';
                      } else if (snapshot.data!.status ==
                          DownloadStatus.STATUS_PENDING) {
                        status = 'Donwload Pending';
                      }
                      if (snapshot.data!.status ==
                          DownloadStatus.STATUS_RUNNING) {
                        status = 'Donwloading';
                      }
                      if (snapshot.data!.status ==
                          DownloadStatus.STATUS_PAUSED) {
                        status = 'Donwloading Paused';
                      }
                    }
                    return Text(
                      '$status',
                      style: Theme.of(context).textTheme.bodyText1,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FadeTransition(
                opacity: _controller,
                child: StreamBuilder(
                  stream: widget.info.androidInfo.downloadStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DownloadInfo> snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${snapshot.hasData ? '${snapshot.data!.getSpeedString()}' : '--mb/s'}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          '${snapshot.hasData ? '${snapshot.data!.percent!.toStringAsFixed(1)} %' : '0.0%'}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            AnimatedPositioned(
              onEnd: () {
                _controller.forward();
              },
              duration: Duration(milliseconds: _kAnimationDuration),
              top: enterNewStatus2 ? 45 : 0,
              left: enterNewStatus2 ? 16 : 0,
              right: enterNewStatus2 ? 16 : 0,
              child: Stack(
                children: [
                  StreamBuilder<DownloadInfo>(
                      stream: widget.info.androidInfo.downloadStream(),
                      builder: (context, AsyncSnapshot<DownloadInfo> snapshot) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.2),
                            ], stops: [
                              1,
                              0
                            ]).createShader(Rect.fromLTWH(
                                0,
                                0,
                                rect.width *
                                    (snapshot.hasData
                                        ? (snapshot.data!.status ==
                                                DownloadStatus.STATUS_SUCCESSFUL
                                            ? 1
                                            : snapshot.data!.percent! / 100)
                                        : 0),
                                rect.height));
                          },
                          child: AnimatedContainer(
                            height: enterNewStatus2 ? 30 : 40,
                            duration:
                                Duration(milliseconds: _kAnimationDuration),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: enterNewStatus2
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(
                                    enterNewStatus2 ? 8 : 0)),
                          ),
                        );
                      }),
                  Center(
                    child: FadeTransition(
                      opacity: Tween(begin: 1.0, end: 0.0).animate(_controller),
                      child: GestureDetector(
                        onTap: () {
                          widget.info.androidInfo.upgradeFromDownload();
                        },
                        child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'Install',
                            style:
                                Theme.of(context).primaryTextTheme.headline6!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildUpgradeContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          alignment: Alignment.centerLeft,
          child: FadeTransition(
            opacity: _controller,
            child: Text(
              '${widget.info.title!}(${widget.info.newVersion}-${widget.info.newVersionCode})',
              style: Theme.of(context).primaryTextTheme.headline6!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(
          height: 160,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: _controller,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0))
                  .animate(_controller),
              child: SingleChildScrollView(
                child: Text(
                  widget.info.content!,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _controller,
          child: Container(
            height: 0.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
        FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0))
                .animate(_controller),
            child: Row(
              children: [
                if (!(widget.info.isForce == true))
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  )),
                if (!(widget.info.isForce == true))
                  FadeTransition(
                    opacity: _controller,
                    child: Container(
                      width: 1,
                      height: 24,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                Expanded(
                    child: TextButton(
                  onPressed: _onUpgrade,
                  child: Text('Upgrade'),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onAndroidDownload() async {
    bool isFinish = await widget.info.androidInfo.checkIsFinish();
    if (!isFinish) {
      final future = _controller.reverse();
      future.whenComplete(() async {
        setState(() {
          enterNewStatus = true;
        });
        widget.info.androidInfo.upgradeFromDownload();
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          setState(() {
            enterNewStatus2 = true;
          });
        });
      });
    } else {
      widget.info.androidInfo.upgradeFromDownload();
    }
  }

  void _onUpgrade() async {
    if (Platform.isAndroid) {
      if (widget.info.androidInfo.downloadUrl != null) {
        _onAndroidDownload();
      } else if (widget.info.androidInfo.webUrl != null) {
        await widget.info.upgradeFromUrl();
      } else {
        widget.info.upgradeFromStore();
      }
    } else if (Platform.isIOS) {
      if (widget.info.iosInfo.appId != null) {
        await widget.info.upgradeFromStore();
      } else {
        await widget.info.upgradeFromUrl();
      }
    }
  }
}
