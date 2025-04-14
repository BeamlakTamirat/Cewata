@echo off
echo Setting up environment for Flutter build with JDK 21...
set JAVA_HOME=C:\Program Files\Java\jdk-21
set PATH=%JAVA_HOME%\bin;%PATH%

echo Cleaning project...
flutter clean

echo Building APK...
flutter build apk --release --split-per-abi

echo Build complete.
echo APKs should be available in build\app\outputs\flutter-apk\
pause 