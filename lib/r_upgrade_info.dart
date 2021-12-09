import 'dart:io';

import 'package:flutter/material.dart';
import 'package:r_upgrade/r_upgrade.dart';

import 'r_upgrade_ui.dart';

class RUpgradeAndroidInfo {
  RUpgradeFlavor upgradeFlavor = RUpgradeFlavor.normal;

  Map<String, String>? downloadHeader;

  String? downloadUrl;

  String? downloadFileName;

  bool? _downloadIsFinish;

  bool? downloadFinishAutoInstall;

  bool? get downloadIsFinish => _downloadIsFinish;

  String? storeId;

  String? webUrl;

  int? _downloadId;

  int? get downloadId => _downloadId;

  NotificationVisibility? notificationVisibility;
  NotificationStyle? notificationStyle;

  Future<bool?> upgradeFromStore() async {
    List<AndroidStore>? storeList = await RUpgrade.androidStores;
    if (storeList != null && storeList.isNotEmpty) {
      AndroidStore store = storeList.first;
      for (final item in storeList) {
        final version = await RUpgrade.getVersionFromAndroidStore(item);
        if (version != null) {
          store = item;
          break;
        }
      }
      return await RUpgrade.upgradeFromAndroidStore(store);
    }
    return false;
  }

  Future<bool> checkIsFinish() async {
    _downloadIsFinish = false;
    _downloadId = await RUpgrade.getLastUpgradedId();
    if (_downloadId != null) {
      final status = await RUpgrade.getDownloadStatus(_downloadId!);
      if (status == DownloadStatus.STATUS_SUCCESSFUL) {
        _downloadIsFinish = true;
        return true;
      }
    }
    return false;
  }

  Future<bool> upgradeFromDownload() async {
    bool shouldRestartDownload = false;
    _downloadIsFinish = false;
    _downloadId = await RUpgrade.getLastUpgradedId();
    if (_downloadId != null) {
      final status = await RUpgrade.getDownloadStatus(_downloadId!);
      if (status == DownloadStatus.STATUS_SUCCESSFUL) {
        _downloadIsFinish = true;
        await RUpgrade.upgradeWithId(_downloadId!);
      } else if (status == DownloadStatus.STATUS_FAILED) {
        shouldRestartDownload = true;
      } else {
        await RUpgrade.upgradeWithId(_downloadId!);
      }
    } else {
      shouldRestartDownload = true;
    }
    if (shouldRestartDownload) {
      assert(downloadUrl != null, 'Please set android downloadUrl');
      _downloadId = await RUpgrade.upgrade(
        downloadUrl!,
        header: downloadHeader,
        fileName: downloadFileName,
        notificationVisibility:
            notificationVisibility ?? NotificationVisibility.VISIBILITY_VISIBLE,
        notificationStyle: notificationStyle ?? NotificationStyle.planTime,
        isAutoRequestInstall: downloadFinishAutoInstall ?? true,
        upgradeFlavor: upgradeFlavor,
      );
    }
    return false;
  }

  Stream<DownloadInfo> downloadStream() => RUpgrade.stream;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RUpgradeAndroidInfo &&
          runtimeType == other.runtimeType &&
          upgradeFlavor == other.upgradeFlavor &&
          downloadHeader == other.downloadHeader &&
          downloadUrl == other.downloadUrl &&
          downloadFileName == other.downloadFileName &&
          _downloadIsFinish == other._downloadIsFinish &&
          downloadFinishAutoInstall == other.downloadFinishAutoInstall &&
          storeId == other.storeId &&
          webUrl == other.webUrl &&
          _downloadId == other._downloadId &&
          notificationVisibility == other.notificationVisibility &&
          notificationStyle == other.notificationStyle;

  @override
  int get hashCode =>
      upgradeFlavor.hashCode ^
      downloadHeader.hashCode ^
      downloadUrl.hashCode ^
      downloadFileName.hashCode ^
      _downloadIsFinish.hashCode ^
      downloadFinishAutoInstall.hashCode ^
      storeId.hashCode ^
      webUrl.hashCode ^
      _downloadId.hashCode ^
      notificationVisibility.hashCode ^
      notificationStyle.hashCode;

  @override
  String toString() {
    return 'RUpgradeAndroidInfo{upgradeFlavor: $upgradeFlavor, downloadHeader: $downloadHeader, downloadUrl: $downloadUrl, downloadFileName: $downloadFileName, _downloadIsFinish: $_downloadIsFinish, downloadFinishAutoInstall: $downloadFinishAutoInstall, storeId: $storeId, webUrl: $webUrl, _downloadId: $_downloadId, notificationVisibility: $notificationVisibility, notificationStyle: $notificationStyle}';
  }
}

class RUpgradeIOSInfo {
  String? appId;

  String? webUrl;

  bool isChina = true;

  Future<bool?> upgradeFromStore() async {
    return await RUpgrade.upgradeFromAppStore(appId!, isChina);
  }
}

class RUpgradeInfo {
  late RUpgradeAndroidInfo androidInfo;

  late RUpgradeIOSInfo iosInfo;

  // force upgrade?
  bool? isForce;

  // upgrade from background?
  bool? isBackground;

  // upgrade title
  String? title;

  // upgrade content
  String? content;

  // new version name
  String? newVersion;

  // new version code
  int? newVersionCode;

  // web url is null.
  bool get webUrlIsNull => androidInfo.webUrl == null && iosInfo.webUrl == null;

  String getWebUrl() {
    String? webUrl;
    if (Platform.isAndroid) {
      webUrl = androidInfo.webUrl;
    } else if (Platform.isIOS) {
      webUrl = iosInfo.webUrl;
    }
    assert(webUrl != null, 'Web url can not null!');
    return webUrl!;
  }

  Future<bool?> upgradeFromUrl() async {
    if (!webUrlIsNull) {
      return await RUpgrade.upgradeFromUrl(getWebUrl());
    }
    return false;
  }

  Future<bool?> upgradeFromStore() async {
    if (Platform.isAndroid) {
      return await androidInfo.upgradeFromStore();
    } else if (Platform.isIOS) {
      return await iosInfo.upgradeFromStore();
    }
  }

  Future<dynamic> showNormalDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: isForce == null || isForce == false,
        builder: (BuildContext context) => RUpgradeNormalDialog(info: this));
  }
}
