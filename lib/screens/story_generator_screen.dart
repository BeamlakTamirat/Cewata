import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../models/story.dart';
import '../screens/settings_screen.dart';
import '../screens/story_details_screen.dart';

class StoryGeneratorScreen extends StatefulWidget {
  final StoryType initialType;

  const StoryGeneratorScreen({
    super.key,
    required this.initialType,
  });

  @override
  State<StoryGeneratorScreen> createState() => _StoryGeneratorScreenState();
}

class _StoryGeneratorScreenState extends State<StoryGeneratorScreen> {
  late StoryType _selectedType;
  AgeGroup _selectedAgeGroup = AgeGroup.allAges;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _amharicTopicController = TextEditingController();
  bool _isAmharicInput = false;

  bool _isGenerating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _amharicTopicController.dispose();
    super.dispose();
  }

  void _generateContent() {
    if (_selectedType == StoryType.fairyTale && _topicController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a topic for your fairy tale';
      });
      return;
    }

    if (_selectedType == StoryType.riddle && _topicController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a topic for your riddle';
      });
      return;
    }

    setState(() {
      _errorMessage = '';
    });

    // Get the topic from the right controller based on input language
    final topic =
        _isAmharicInput ? _amharicTopicController.text : _topicController.text;

    // Use the StoryProvider to generate content
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    storyProvider
        .generateStory(
      type: _selectedType,
      topic: topic.trim(),
      ageGroup: _selectedAgeGroup,
      isAmharicInput: _isAmharicInput,
    )
        .then((story) {
      if (story != null) {
        // Navigate to the story details screen
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailsScreen(story: story),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storyProvider = Provider.of<StoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedType == StoryType.fairyTale ? 'New FairyTale' : 'New Riddle',
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: storyProvider.isLoading
          ? _buildLoadingIndicator()
          : Consumer<StoryProvider>(
              builder: (context, provider, child) {
                if (provider.dataSavingMode) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.data_saver_on,
                            size: 80,
                            color: theme.colorScheme.primary.withOpacity(0.6),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Data Saving Mode is On',
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Story generation is disabled to save data. Turn off Data Saving Mode in Settings to create new fairy tales.',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings),
                            label: const Text('Go to Settings'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top banner with selected type
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _selectedType == StoryType.fairyTale
                              ? 'Creating a new bilingual FairyTale in English and Amharic'
                              : 'Creating a new bilingual riddle in English and Amharic',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Content type selection
                            Text(
                              'Content Type',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTypeOption(StoryType.fairyTale),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTypeOption(StoryType.riddle),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Language toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Input Language',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: _isAmharicInput,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAmharicInput = value;
                                    });
                                  },
                                  activeColor: theme.colorScheme.primary,
                                  activeTrackColor: theme.colorScheme.primary
                                      .withOpacity(0.4),
                                  inactiveThumbColor: theme.colorScheme.primary,
                                  inactiveTrackColor: theme
                                      .colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ],
                            ),

                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isAmharicInput = false;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: !_isAmharicInput
                                            ? theme.colorScheme.primary
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        'English',
                                        style: TextStyle(
                                          color: !_isAmharicInput
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                          fontWeight: !_isAmharicInput
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isAmharicInput = true;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: _isAmharicInput
                                            ? theme.colorScheme.primary
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: Text(
                                        'አማርኛ',
                                        style: TextStyle(
                                          color: _isAmharicInput
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                          fontWeight: _isAmharicInput
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Topic input
                            Text(
                              _isAmharicInput
                                  ? 'ርዕስ ወይም ገጽታ'
                                  : 'Topic or Theme',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Improved input fields
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: _isAmharicInput
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: TextField(
                                  controller: _topicController,
                                  decoration: InputDecoration(
                                    hintText: _selectedType ==
                                            StoryType.fairyTale
                                        ? 'e.g., Ethiopian culture, friendship, animals...'
                                        : 'e.g., moon, water, time...',
                                    prefixIcon: Icon(
                                      Icons.topic,
                                      color: theme.colorScheme.primary,
                                    ),
                                    errorText: !_isAmharicInput &&
                                            _errorMessage.isNotEmpty
                                        ? _errorMessage
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              secondChild: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: TextField(
                                  controller: _amharicTopicController,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    hintText: _selectedType ==
                                            StoryType.fairyTale
                                        ? 'ለምሳሌ፡ የኢትዮጵያ ባህል፣ ወዳጅነት፣ እንስሳት...'
                                        : 'ለምሳሌ፡ ጨረቃ፣ ውሃ፣ ጊዜ...',
                                    prefixIcon: Icon(
                                      Icons.topic,
                                      color: theme.colorScheme.primary,
                                    ),
                                    errorText: _isAmharicInput &&
                                            _errorMessage.isNotEmpty
                                        ? _errorMessage
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Age group selection
                            Text(
                              _isAmharicInput ? 'የእድሜ ቡድን' : 'Age Group',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAgeOption(
                                      AgeGroup.children,
                                      _isAmharicInput
                                          ? 'ልጆች (5-12)'
                                          : 'Children (5-12)'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAgeOption(AgeGroup.allAges,
                                      _isAmharicInput ? 'ሁሉም እድሜ' : 'All Ages'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 48),

                            // Generate button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: storyProvider.isLoading
                                    ? null
                                    : () => _generateContent(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                child: storyProvider.isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text('Creating...',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                color: Colors.white,
                                              )),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.auto_stories),
                                          const SizedBox(width: 8),
                                          Text(_selectedType ==
                                                  StoryType.fairyTale
                                              ? 'Create New FairyTale'
                                              : 'Create New Riddle'),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  _isAmharicInput
                                      ? 'በሚፈልጉት ርዕስ ላይ ${_selectedType == StoryType.fairyTale ? "ተረት" : "እንቆቅልሽ"} ያግኙ።'
                                      : 'Get a ${_selectedType == StoryType.fairyTale ? 'FairyTale' : 'riddle'} on any topic of your choice.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTypeOption(StoryType type) {
    final theme = Theme.of(context);
    final isSelected = _selectedType == type;
    final isFairyTale = type == StoryType.fairyTale;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFairyTale ? Icons.auto_stories : Icons.lightbulb,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              isFairyTale ? 'Fairy Tale' : 'Riddle',
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeOption(AgeGroup ageGroup, String label) {
    final isSelected = _selectedAgeGroup == ageGroup;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAgeGroup = ageGroup;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ageGroup == AgeGroup.children ? Icons.child_care : Icons.people,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
