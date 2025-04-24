@echo off
echo ===== FLUTTER BUILD WITH COMPATIBLE JAVA VERSION =====

echo 1. Setting environment variables for Java 17 (compatible with Gradle)...
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%

echo 2. Verifying Java version...
java -version

echo 3. Updating gradle.properties for compatibility...
(
echo org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
echo android.useAndroidX=true
echo android.enableJetifier=true
echo org.gradle.java.home=C:\\Program Files\\Java\\jdk-17
echo android.overrideVersionCheck=true
echo kotlin.stdlib.default.dependency=false
) > android\gradle.properties

echo 4. Creating compatibility fix for build.gradle...
(
echo // Fix for Kotlin version compatibility issues
echo rootProject.allprojects {
echo     configurations.all {
echo         resolutionStrategy {
echo             force 'org.jetbrains.kotlin:kotlin-stdlib:1.8.10'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-common:1.8.10'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.10'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.10'
echo         }
echo     }
echo }
) > android\kotlin_fix.gradle

echo 5. Updating build.gradle...
echo apply from: 'kotlin_fix.gradle' >> android\build.gradle

echo 6. Fixing Java compilation for app build.gradle...
(
echo android {
echo     // Other settings will be preserved
echo     compileOptions {
echo         sourceCompatibility JavaVersion.VERSION_17
echo         targetCompatibility JavaVersion.VERSION_17
echo     }
echo    
echo     kotlinOptions {
echo         jvmTarget = '17'
echo     }
echo }
) > android\app\java_fix.txt

echo 7. Applying Java fixes...
cd android\app
findstr /v "compileOptions kotlinOptions" build.gradle > build.gradle.tmp
type build.gradle.tmp > build.gradle
type java_fix.txt >> build.gradle
cd ..\..

echo 8. Cleaning project and Gradle cache...
flutter clean
cd android
call gradlew clean --stop
cd ..

echo 9. Getting dependencies...
flutter pub get

echo 10. Building APK with debug options...
flutter build apk --debug

echo Build process complete.
echo If successful, check for APKs in: build\app\outputs\flutter-apk\
pause 