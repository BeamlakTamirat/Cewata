import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../models/story.dart';
import '../providers/story_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class StoryDetailsScreen extends StatefulWidget {
  final Story story;

  const StoryDetailsScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  bool _isRiddleAnswerVisible = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool _isEnglishSide = true;

  @override
  void initState() {
    super.initState();
    // Mark the story as viewed when the details screen is opened
    if (!widget.story.hasBeenViewed) {
      widget.story.markAsViewed();
      // Notify listeners to update UI if needed
      Future.microtask(() {
        final storyProvider =
            Provider.of<StoryProvider>(context, listen: false);
        storyProvider.notifyListeners();
      });
    }
  }

  Future<void> _deleteStory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this content?', textAlign: TextAlign.center),
        content: Text(
          'Are you sure you want to delete "${widget.story.titleEn}"? This action cannot be undone.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      storyProvider.removeStory(widget.story);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _shareContent() async {
    // This would use a sharing package in a real app
    final content = '''
${widget.story.titleEn}
${widget.story.titleAm}

${widget.story.contentEn}

${widget.story.contentAm}
''';

    await Clipboard.setData(ClipboardData(text: content));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Content copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      decoration: AppTheme.gradientBackground(isDark: isDarkMode),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.story.type == StoryType.fairyTale
              ? 'Fairy Tale'
              : 'Riddle'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareContent,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteStory,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Language selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEnglishSide = true;
                      });
                      if (!_isEnglishSide) {
                        cardKey.currentState?.toggleCard();
                      }
                    },
                    icon: Icon(
                      Icons.language,
                      color: _isEnglishSide
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                    label: Text(
                      'English',
                      style: TextStyle(
                        color: _isEnglishSide
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onBackground.withOpacity(0.5),
                        fontWeight: _isEnglishSide
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEnglishSide = false;
                      });
                      if (_isEnglishSide) {
                        cardKey.currentState?.toggleCard();
                      }
                    },
                    icon: Icon(
                      Icons.language,
                      color: !_isEnglishSide
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                    label: Text(
                      'አማርኛ',
                      style: TextStyle(
                        color: !_isEnglishSide
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onBackground.withOpacity(0.5),
                        fontWeight: !_isEnglishSide
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Flip card for content
              FlipCard(
                key: cardKey,
                direction: FlipDirection.HORIZONTAL,
                speed: 500,
                onFlip: () {
                  setState(() {
                    _isEnglishSide = !_isEnglishSide;
                  });
                },
                flipOnTouch: true,
                front: _buildContentCard(
                  title: widget.story.titleEn,
                  content: widget.story.contentEn,
                  answer: widget.story.answerEn,
                  language: 'en',
                ),
                back: _buildContentCard(
                  title: widget.story.titleAm,
                  content: widget.story.contentAm,
                  answer: widget.story.answerAm,
                  language: 'am',
                ),
              ),

              const SizedBox(height: 16),

              // Flip instruction
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tap card to flip between languages',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required String content,
    String? answer,
    required String language,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.story.type == StoryType.fairyTale
                      ? Icons.book
                      : Icons.lightbulb,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Topic
            Center(
              child: Chip(
                label: Text(
                  widget.story.topic,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                labelStyle: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),

            // Answer for riddles
            if (widget.story.type == StoryType.riddle && answer != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isRiddleAnswerVisible = !_isRiddleAnswerVisible;
                  });
                },
                icon: Icon(_isRiddleAnswerVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
                label: Text(
                    _isRiddleAnswerVisible ? 'Hide Answer' : 'Show Answer'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              if (_isRiddleAnswerVisible) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        language == 'en' ? 'Answer:' : 'መልስ:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        answer,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
