@echo off
echo ===== FLUTTER BUILD WITH JAVA 21 AND KOTLIN FIX =====

echo 1. Setting environment variables...
set JAVA_HOME=C:\Program Files\Java\jdk-21
set PATH=%JAVA_HOME%\bin;%PATH%

echo 2. Verifying Java version...
java -version

echo 3. Creating patch for shared_preferences Kotlin compatibility...
mkdir -p patches
(
echo // Kotlin compatibility fix
echo package io.flutter.plugins.sharedpreferences;
echo 
echo import java.util.*;
echo 
echo public class KotlinExtensionFunctions {
echo     public static boolean startsWith(String source, String prefix) {
echo         return source.startsWith(prefix);
echo     }
echo 
echo     public static String substring(String source, int startIndex) {
echo         return source.substring(startIndex);
echo     }
echo 
echo     public static String substring(String source, int startIndex, int endIndex) {
echo         return source.substring(startIndex, endIndex);
echo     }
echo 
echo     public static ^<T^> List^<T^> filterIsInstance(Collection^<?^> source, Class^<T^> klass) {
echo         List^<T^> result = new ArrayList^<^>();
echo         for (Object item : source) {
echo             if (klass.isInstance(item)) {
echo                 result.add(klass.cast(item));
echo             }
echo         }
echo         return result;
echo     }
echo 
echo     public static ^<T^> Set^<T^> setOf(T... elements) {
echo         return new HashSet^<^>(Arrays.asList(elements));
echo     }
echo }
) > patches\KotlinExtensionFunctions.java

echo 4. Updating gradle.properties...
(
echo org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
echo android.useAndroidX=true
echo android.enableJetifier=true
echo org.gradle.java.home=C:\\Program Files\\Java\\jdk-21
echo android.overrideVersionCheck=true
echo org.gradle.warning.mode=all
echo org.gradle.parallel=true
echo kotlin.stdlib.default.dependency=false
echo # Fix for shared_preferences Kotlin version issues
echo kotlin.jvm.target.validation.mode=warning
echo kotlin.incremental=false
) > android\gradle.properties

echo 5. Creating fix for build.gradle...
(
echo // Fix for Kotlin version compatibility issues
echo rootProject.allprojects {
echo     configurations.all {
echo         resolutionStrategy {
echo             force 'org.jetbrains.kotlin:kotlin-stdlib:1.9.0'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-common:1.9.0'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.0'
echo             force 'org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0'
echo             force 'org.jetbrains.kotlin:kotlin-reflect:1.9.0'
echo         }
echo     }
echo     
echo     tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile).configureEach {
echo         kotlinOptions {
echo             jvmTarget = "21"
echo             freeCompilerArgs += [
echo                 "-Xskip-metadata-version-check",
echo                 "-Xjvm-default=all"
echo             ]
echo         }
echo     }
echo }
) > android\kotlin_fix.gradle

echo 6. Updating build.gradle...
echo apply from: 'kotlin_fix.gradle' >> android\build.gradle

echo 7. Cleaning project...
flutter clean

echo 8. Cleaning Gradle cache...
cd android && call gradlew clean --stop
cd ..

echo 9. Getting dependencies...
flutter pub get

echo 10. Building APK with debug options...
flutter build apk --debug

echo Build process complete.
echo If successful, check for APKs in: build\app\outputs\flutter-apk\
pause 