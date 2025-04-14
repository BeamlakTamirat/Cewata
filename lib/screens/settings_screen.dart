import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../providers/story_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16;
  bool _dataSavingMode = false;
  double _textSize = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16;
      _textSize = prefs.getDouble('textSize') ?? 1.0;
    });

    // Load data saving mode from the StoryProvider
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    setState(() {
      _dataSavingMode = storyProvider.dataSavingMode;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setDouble('textSize', _textSize);

    // Update data saving mode in the StoryProvider
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    storyProvider.dataSavingMode = _dataSavingMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _buildSectionHeader('Appearance'),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Theme'),
                  subtitle: const Text('Light, dark, or system default'),
                  leading: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: theme.colorScheme.primary,
                  ),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeProvider.themeMode,
                    underline: const SizedBox(),
                    onChanged: (ThemeMode? newMode) {
                      if (newMode != null) {
                        themeProvider.setThemeMode(newMode);
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(
                            'System (${MediaQuery.of(context).platformBrightness == Brightness.dark ? 'Dark' : 'Light'})'),
                      ),
                      const DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      const DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Text Size'),
                  subtitle: Text(
                    'Adjust the size of text throughout the app: ${_textSize.toStringAsFixed(1)}',
                  ),
                  trailing: SizedBox(
                    width: 150,
                    child: Slider(
                      value: _textSize,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      label: _textSize.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _textSize = value;
                        });
                        _savePreferences();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Saving Mode section
          _buildSectionHeader('Data Usage'),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text('Data Saving Mode'),
              subtitle: const Text(
                'Disable fairy tale generation to save data usage',
              ),
              value: _dataSavingMode,
              onChanged: (bool value) {
                setState(() {
                  _dataSavingMode = value;
                });
                _savePreferences();
              },
              secondary: Icon(
                Icons.data_saver_on,
                color: theme.colorScheme.primary,
              ),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          // About section
          _buildSectionHeader('About'),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Developer'),
                  subtitle: const Text('Beamlak Tamirat'),
                  leading: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  title: const Text('About This App'),
                  subtitle: const Text('Learn more about ጨዋታ (Chewata)'),
                  leading: Icon(
                    Icons.question_mark,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('About ጨዋታ'),
                        content: const SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'This app was created for children and adults alike to play, cheer, and communicate through engaging riddles and stories.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'ጨዋታ brings Ethiopian culture to life through interactive stories and brain teasers that entertain while educating about Amharic language and Ethiopian heritage.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Enjoy creating and sharing your own stories and riddles with friends and family!',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CLOSE'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
