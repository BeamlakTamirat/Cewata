import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/story.dart';
import '../providers/story_provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import 'story_generator_screen.dart';
import 'story_details_screen.dart';
import 'settings_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add listener to rebuild when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          title: const Text('ጨዋታ', style: TextStyle(fontSize: 24)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: isDarkMode ? AppColors.textDark : AppColors.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Fairy Tales',
                icon: Icon(Icons.auto_stories),
              ),
              Tab(
                text: 'Riddles',
                icon: Icon(Icons.lightbulb),
              ),
            ],
            indicatorWeight: 3,
            indicatorColor: isDarkMode
                ? theme.colorScheme.secondary
                : theme.colorScheme.secondary,
            labelColor: isDarkMode ? AppColors.textDark : AppColors.primary,
            unselectedLabelColor: isDarkMode
                ? AppColors.textDark.withOpacity(0.6)
                : AppColors.text.withOpacity(0.6),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Background pattern overlay
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(
                  primaryColor: isDarkMode
                      ? AppColors.primaryDark
                      : theme.colorScheme.primary,
                  secondaryColor: isDarkMode
                      ? AppColors.secondaryDark
                      : theme.colorScheme.secondary,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),
            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical category list on the left - fixed in place
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.7),
                    border: Border(
                      right: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _getCategories().length,
                    itemBuilder: (context, index) {
                      final category = _getCategories()[index];
                      final isSelected = _selectedCategory == category;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          title: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          dense: true,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Content area on the right
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildContentList(StoryType.fairyTale),
                      _buildContentList(StoryType.riddle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryGeneratorScreen(
                  initialType: _tabController.index == 0
                      ? StoryType.fairyTale
                      : StoryType.riddle,
                ),
              ),
            );
          },
          backgroundColor: theme.colorScheme.primary,
          elevation: 4,
          icon: const Icon(Icons.add),
          label:
              Text(_tabController.index == 0 ? 'New Fairy Tale' : 'New Riddle'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  List<String> _getCategories() {
    List<String> categories = ['All'];
    categories.addAll(StoryCategory.values
        .where((c) => c != StoryCategory.userCreated)
        .map((c) => _getCategoryDisplayName(c))
        .toList());
    return categories;
  }

  Widget _buildContentList(StoryType type) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        final theme = Theme.of(context);

        if (storyProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading content...',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // Get all stories of the current type
        List<Story> allStories =
            storyProvider.stories.where((s) => s.type == type).toList();

        // If no stories, show empty state
        if (allStories.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type == StoryType.fairyTale
                        ? Icons.auto_stories
                        : Icons.lightbulb_outline,
                    size: 80,
                    color: theme.colorScheme.primary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No ${type == StoryType.fairyTale ? 'FairyTales' : 'riddles'} yet',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first ${type == StoryType.fairyTale ? 'FairyTale' : 'riddle'}',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Filter stories based on selected category
        List<Story> stories = allStories;
        if (_selectedCategory != 'All') {
          // Find the category enum from the display name
          final categoryEnum = StoryCategory.values.firstWhere(
            (c) => _getCategoryDisplayName(c) == _selectedCategory,
            orElse: () => StoryCategory.userCreated,
          );
          stories =
              allStories.where((s) => s.category == categoryEnum).toList();
        }

        return stories.isEmpty
            ? Center(
                child: Text(
                  'No ${type == StoryType.fairyTale ? 'FairyTales' : 'riddles'} in this category',
                  style: theme.textTheme.bodyLarge,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return _buildStoryCard(context, story);
                },
              );
      },
    );
  }

  String _getCategoryDisplayName(StoryCategory category) {
    switch (category) {
      case StoryCategory.animals:
        return 'Animals';
      case StoryCategory.nature:
        return 'Nature';
      case StoryCategory.culture:
        return 'Culture';
      case StoryCategory.history:
        return 'History';
      case StoryCategory.family:
        return 'Family';
      case StoryCategory.friendship:
        return 'Friendship';
      case StoryCategory.wisdom:
        return 'Wisdom';
      case StoryCategory.userCreated:
        return 'User Created';
    }
  }

  Widget _buildStoryCard(BuildContext context, Story story) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isNew = story.isNew;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryDetailsScreen(story: story),
            ),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                story.titleEn,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (story.category != StoryCategory.userCreated)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  story.getCategoryName(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.titleAm,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.contentEn.length > 120
                              ? '${story.contentEn.substring(0, 120)}...'
                              : story.contentEn,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    story.type == StoryType.fairyTale
                                        ? Icons.auto_stories
                                        : Icons.lightbulb,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    story.type == StoryType.fairyTale
                                        ? 'FairyTale'
                                        : 'Riddle',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Read more',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // NEW badge
              if (isNew)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom background pattern painter for a more subtle dark overlay pattern
class BackgroundPatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDarkMode;

  BackgroundPatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle grid lines
    final linePaint = Paint()
      ..color = primaryColor.withOpacity(isDarkMode ? 0.15 : 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Horizontal lines
    for (int i = 0; i < 20; i++) {
      final y = size.height * (i / 20.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Vertical lines
    for (int i = 0; i < 10; i++) {
      final x = size.width * (i / 10.0);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Draw scattered dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 1.0 + random.nextDouble() * 2.0;

      if (i % 3 == 0) {
        dotPaint.color = primaryColor.withOpacity(isDarkMode ? 0.2 : 0.05);
      } else if (i % 3 == 1) {
        dotPaint.color = secondaryColor.withOpacity(isDarkMode ? 0.15 : 0.05);
      } else {
        dotPaint.color =
            (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05);
      }

      canvas.drawCircle(Offset(x, y), radius, dotPaint);
    }

    // Draw a subtle darkening/lightening overlay
    final overlayPaint = Paint()
      ..color = (isDarkMode ? Colors.black : Colors.black)
          .withOpacity(isDarkMode ? 0.4 : 0.03)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
