import 'package:flutter/material.dart';
import '../widgets/game_button.dart';
import '../utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'settings_screen.dart';
import 'game_screen.dart';
import 'two_player_screen.dart';
import 'wifi_connection_screen.dart';

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
                    const SizedBox(height: 32),
                    GameButton(
                      text: 'VS AI',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GameScreen(isVsAI: true),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: '2 Players',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TwoPlayerScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      text: 'WiFi Multiplayer',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WifiConnectionScreen(),
                        ),
                      ),
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
