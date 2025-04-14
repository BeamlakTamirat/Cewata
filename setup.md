# Setup Instructions

This document provides detailed instructions for setting up the Amharic & English Stories app for development.

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Git](https://git-scm.com/downloads)
- A code editor (VS Code, Android Studio, etc.)
- A Google Gemini API key (get one from [Google AI Studio](https://ai.google.dev/))

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/amharic_english_stories.git
cd amharic_english_stories
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Key

1. Open the `.env` file in the project root
2. Replace `your_api_key_here` with your actual Gemini API key:
   ```
   GEMINI_API_KEY=your_actual_key_here
   ```

### 4. Create Required Directories

If they don't already exist, create the following directories:

```bash
# For Windows
mkdir assets\images assets\animations assets\audio

# For macOS/Linux
mkdir -p assets/images assets/animations assets/audio
```

### 5. Run the App

Connect a device or start an emulator, then run:

```bash
flutter run
```

## Troubleshooting

### Common Issues

1. **Packages not found**: Make sure you've run `flutter pub get` successfully
2. **API key issues**: Verify your Gemini API key is correct in the `.env` file
3. **Missing assets**: Ensure that all required asset directories exist
4. **Build errors**: Try running `flutter clean` followed by `flutter pub get`

### Platform-Specific Setup

#### Android

Make sure your `AndroidManifest.xml` has the required permissions:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS

Ensure your `Info.plist` has the necessary entries for any features like text-to-speech.

## Creating a Production Build

### Android

```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

Then use Xcode to archive and distribute the app.

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Google Generative AI Documentation](https://ai.google.dev/docs)
- [Provider Package Documentation](https://pub.dev/documentation/provider/latest/)

## Need Help?

If you encounter any issues during setup, please:

1. Check the Flutter documentation
2. Verify your Flutter setup with `flutter doctor`
3. Open an issue in the GitHub repository 