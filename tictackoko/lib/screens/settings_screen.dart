import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/game_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String getDifficultyText(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.easy:
        return 'AI Level: Easy';
      case AIDifficulty.medium:
        return 'AI Level: Medium';
      case AIDifficulty.hard:
        return 'AI Level: Hard';
    }
  }

  AIDifficulty getNextDifficulty(AIDifficulty current) {
    switch (current) {
      case AIDifficulty.easy:
        return AIDifficulty.medium;
      case AIDifficulty.medium:
        return AIDifficulty.hard;
      case AIDifficulty.hard:
        return AIDifficulty.easy;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GameButton(
                    text: '',
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'SETTINGS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'ClashGrotesk',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(
              child: settingsAsync.when(
                data: (settings) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GameButton(
                          text: settings.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          onPressed: () => ref
                              .read(settingsNotifierProvider.notifier)
                              .toggleTheme(),
                        ),
                        const SizedBox(height: 16),
                        GameButton(
                          text: getDifficultyText(settings.aiDifficulty),
                          onPressed: () => ref
                              .read(settingsNotifierProvider.notifier)
                              .setAIDifficulty(
                                  getNextDifficulty(settings.aiDifficulty)),
                        ),
                        const SizedBox(height: 16),
                        GameButton(
                          text: 'Source Code',
                          onPressed: () async {
                            final url = Uri.parse(
                                'https://github.com/Dukeazeta/tictackoko');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
