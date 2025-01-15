import 'package:flutter/material.dart';
import '../widgets/game_button.dart';
import '../utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameButton(
                      text: 'VS AI',
                      onPressed: () {
                        // TODO: Navigate to AI game screen
                      },
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: '2 Players',
                      onPressed: () {
                        // TODO: Navigate to 2 players game screen
                      },
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'WiFi Multiplayer',
                      onPressed: () {
                        // TODO: Navigate to WiFi multiplayer screen
                      },
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'Settings',
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'v${AppColors.version}',
                style: const TextStyle(
                  fontFamily: 'ClashGrotesk',
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
