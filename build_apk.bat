@echo off
echo Building Flutter APK with Java 11...

echo 1. Setting environment variables...
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%

echo 2. Verifying Java version...
java -version

echo 3. Cleaning project...
flutter clean

echo 4. Cleaning Gradle cache...
cd android
call gradlew clean
cd ..

echo 5. Getting dependencies...
flutter pub get

echo 6. Building APK (regular)...
flutter build apk --no-shrink

echo Build process complete.
echo Check for APKs in: build\app\outputs\flutter-apk\
pause 