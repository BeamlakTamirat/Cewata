@echo off
echo FIXING FLUTTER BUILD WITH JAVA 21

echo Step 1: Kill any lingering Gradle daemons
taskkill /F /IM java.exe

echo Step 2: Clean Flutter project
flutter clean

echo Step 3: Updating environment
set JAVA_HOME=C:\Program Files\Java\jdk-21
set PATH=%JAVA_HOME%\bin;%PATH%

echo Step 4: Getting dependencies
flutter pub get

echo Step 5: Building debug APK 
flutter build apk --debug

echo Step 6: Check if build succeeded
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
  echo BUILD SUCCESSFUL! Debug APK created.
  echo You can find your APK at: build\app\outputs\flutter-apk\app-debug.apk
) else (
  echo BUILD FAILED. Please check the logs above for errors.
)

pause 