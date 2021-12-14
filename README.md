## r_upgrade_ui
[![pub package](https://img.shields.io/pub/v/r_upgrade_ui.svg)](https://pub.dartlang.org/packages/r_upgrade_ui)

[r_upgrade](https://pub.dev/packages/r_upgrade) UI Packages,simple to use.

## How to use?

1. add plugin to your `pubspec.yaml`

```yaml
dependencies:
  r_upgrade_ui: last_version
```

2. Create RUpgradeInfo class.

```dart

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
```

3. Use Normal Download Dialog.

```dart
    rUpgradeInfo.showNormalDialog(context);
```

4. android upgrade method.

```dart
  // upgrade from store
rUpgradeInfo.androidInfo.upgradeFromStore();

// upgrade from download
rUpgradeInfo.androidInfo.upgradeFromDownload();
```

5. ios upgrade method.

```dart
  // upgrade from store
rUpgradeInfo.iosInfo.upgradeFromStore();

```

6. share method.

```dart
  // upgrade from store
rUpgradeInfo.upgradeFromStore();

// upgrade from url
rUpgradeInfo.upgradeFromUrl();
```

## LICENSE

    Copyright 2021 The r_upgrade_ui Project Authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
