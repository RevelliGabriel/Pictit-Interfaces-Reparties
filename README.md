# pierre-gabriel-antoine-revelli-boulat


building & launching backend with :
```shell
cd back
npm install
npm start
```

building & launching frontend with :
```shell
cd front
flutter pub get
adb devices
adb -s <DEVICE_NAME> reverse tcp:3000 tcp:3000
flutter run -d chrome lib\board_launcher.dart
flutter run -d <DEVICE_NAME> lib\player_launcher.dart
```