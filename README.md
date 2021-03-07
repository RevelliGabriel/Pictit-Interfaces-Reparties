# Pictit

## Building and Lauching applications

building & launching backend with :
```shell
cd back
npm install
npm start
```

building & launching frontend board view with :
```shell
cd front
flutter pub get
flutter run -d chrome lib\board_launcher.dart
```

building & launching frontend player view on phone with :
```shell
cd front
flutter pub get
adb devices
adb -s <DEVICE_NAME> reverse tcp:3000 tcp:3000
flutter run -d <DEVICE_NAME> lib\player_launcher.dart
```

## Informations on back structure

[Back structure](back/README.md)

## Informations on front structure

[Front structure](front/README.md)