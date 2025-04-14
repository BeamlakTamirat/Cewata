@echo off
echo This script will help you build your APK by temporarily switching to Java 11

echo 1. Checking for Java 11 installation...
WHERE java >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Java not found. Please install Java 11 (AdoptOpenJDK) from:
    echo https://adoptium.net/temurin/releases/?version=11
    echo After installing, run this script again.
    pause
    exit /b
)

echo 2. Saving current JAVA_HOME...
set OLD_JAVA_HOME=%JAVA_HOME%

echo 3. Downloading and installing Java 11 (AdoptOpenJDK) if not already installed...
echo Please download Java 11 from https://adoptium.net/temurin/releases/?version=11 
echo Install it and then enter the path below (e.g. C:\Program Files\Eclipse Adoptium\jdk-11.0.20.8-hotspot)
set /p JAVA_HOME_11="Enter Java 11 path: "

echo 4. Setting JAVA_HOME to Java 11...
set JAVA_HOME=%JAVA_HOME_11%
set PATH=%JAVA_HOME%\bin;%PATH%

echo JAVA_HOME now set to: %JAVA_HOME%

echo 5. Verifying Java version...
java -version

echo 6. Cleaning Flutter project...
flutter clean

echo 7. Getting dependencies...
flutter pub get

echo 8. Building APK with Java 11...
flutter build apk --debug

echo 9. Checking if build succeeded...
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo BUILD SUCCESSFUL! Debug APK created.
    echo You can find your APK at: build\app\outputs\flutter-apk\app-debug.apk
    echo Now building release APK...
    flutter build apk --release
) else (
    echo BUILD FAILED. Please check the logs above for errors.
)

echo 10. Restoring original JAVA_HOME...
set JAVA_HOME=%OLD_JAVA_HOME%
set PATH=%JAVA_HOME%\bin;%PATH%

echo Done! APK building process complete.
pause 