@echo off
flutter build apk --debug
adb install -r build\app\outputs\flutter-apk\app-debug.apk
flutter attach