# Animation Assets

This directory is for storing animation files (Lottie animations) for the app.

## Recommended Animations

For the best user experience, consider adding the following animations:

1. **Splash Animation**: A welcoming animation showing a book opening or pages turning
2. **Loading Animation**: For use while generating content with Gemini AI
3. **Empty State Animation**: For when no stories/riddles have been created yet
4. **Success Animation**: To show when content is successfully generated
5. **Error Animation**: For API or generation errors

## Where to Find Animations

- [LottieFiles](https://lottiefiles.com/) - Many free animations in Lottie format
- [Icons8](https://icons8.com/animations) - High-quality animations in various formats

## Implementation

To use Lottie animations in the app:

1. Download the animation as a `.json` file
2. Place it in this directory
3. Use it in your code with the Lottie package:

```dart
Lottie.asset(
  'assets/animations/your_animation.json',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)
```

Ensure that animations match the app's theme and style for a cohesive user experience. 