# CEWATA  ->  Amharic & English FairyTales & Riddles

A beautiful bilingual storytelling and riddles app powered by Google's Gemini AI. This app generates engaging fairy tales and riddles in both English and Amharic.

## Features

- **Bilingual Content**: Generate and read content in both English and Amharic
- **Multiple Content Types**: Create both fairytales and riddles
- **Age-Appropriate Content**: Select content for children or all ages
- **Beautiful UI**: Modern, intuitive interface with animations
- **Dark Mode**: Switch between light and dark themes
- **Offline Access**: Save generated content for offline reading

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Google Gemini API key (get one from [Google AI Studio](https://ai.google.dev/))

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/amharic_english_stories.git
   cd amharic_english_stories
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Add your Gemini API key:
   - Open the `.env` file in the root directory
   - Replace `your_api_key_here` with your actual Gemini API key
   
   ```
   GEMINI_API_KEY=your_actual_key_here
   ```

4. Run the app:
   ```
   flutter run
   ```

## How to Use

1. **Generate Content**:
   - Tap the "+" button on the home screen
   - Choose between FairyTale or Riddle
   - Enter a topic or theme
   - Select the target age group
   - Tap "Generate"

2. **Read Content**:
   - Tap on any FairyTale or Riddle from the list
   - Switch between English and Amharic using the tabs
   - For riddles, tap "Reveal Answer" to see the solution


3. **Customize Settings**:
   - Access the settings page from the home screen
   - Change theme preferences
   - Update your Gemini API key if needed

## Technical Implementation

- Built with Flutter for cross-platform compatibility
- Uses Google's Generative AI (Gemini) for content generation
- Provider pattern for state management
- Material 3 design principles
- Animation effects for enhanced user experience


## License

This project is licensed under the MIT License - see the LICENSE file for details.
