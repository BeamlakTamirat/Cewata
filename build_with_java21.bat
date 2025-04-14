@echo off
echo Starting APK build with Java 21...

echo 1. Setting environment...
set JAVA_HOME=C:\Program Files\Java\jdk-21
set PATH=%JAVA_HOME%\bin;%PATH%

echo 2. Cleaning project...
flutter clean

echo 3. Optimizing Gradle settings...
echo android.overrideVersionCheck=true >> android\gradle.properties

echo 4. Run gradlew clean in Android directory...
cd android
call gradlew clean --info

echo 5. Run flutter pub get...
cd ..
flutter pub get

echo 6. Building APK (debug mode first)...
flutter build apk --debug

echo 7. If debug succeeded, building release APK...
flutter build apk --release

echo Build process completed.
echo Check the output for any errors.
pause 