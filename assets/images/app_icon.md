# App Icon Instructions

To generate a custom app icon for the Amharic-English Storytelling app, you will need to:

1. Create a high-resolution icon image (1024x1024px) with a relevant design for the app.
   
   Suggested design elements:
   - A book or pages
   - Elements from Ethiopian culture
   - Dual language representation
   - Child-friendly design

2. Use the `flutter_launcher_icons` package to generate icons for all platforms:

   a. Add the dependency to pubspec.yaml:
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   ```

   b. Create a flutter_launcher_icons.yaml file in the root directory:
   ```yaml
   flutter_icons:
     android: "launcher_icon"
     ios: true
     image_path: "assets/images/app_icon.png"
     min_sdk_android: 21
     web:
       generate: true
     windows:
       generate: true
     macos:
       generate: true
   ```

   c. Place your icon as app_icon.png in the assets/images/ directory

   d. Run the generator:
   ```
   flutter pub run flutter_launcher_icons
   ```

This will generate appropriate icons for all platforms using your custom design. 