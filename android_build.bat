@echo off
echo Setting up environment for direct Android build with JDK 21...
set JAVA_HOME=C:\Program Files\Java\jdk-21
set PATH=%JAVA_HOME%\bin;%PATH%

cd android

echo Running direct Gradle build...
call gradlew assembleDebug --stacktrace

echo Build complete! Check for APK in android\app\build\outputs\apk\debug\
pause 