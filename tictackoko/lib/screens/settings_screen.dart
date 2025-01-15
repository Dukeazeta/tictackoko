import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/game_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GameButton(
                      text: settings.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      onPressed: () => ref.read(settingsNotifierProvider.notifier).toggleTheme(),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'AI: Easy',
                      onPressed: () => ref.read(settingsNotifierProvider.notifier)
                          .setAIDifficulty(AIDifficulty.easy),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'AI: Medium',
                      onPressed: () => ref.read(settingsNotifierProvider.notifier)
                          .setAIDifficulty(AIDifficulty.medium),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'AI: Hard',
                      onPressed: () => ref.read(settingsNotifierProvider.notifier)
                          .setAIDifficulty(AIDifficulty.hard),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'Source Code',
                      onPressed: () async {
                        final url = Uri.parse('https://github.com/yourusername/tictackoko');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
