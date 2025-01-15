import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/multiplayer_provider.dart';
import '../utils/constants.dart';
import 'wifi_game_screen.dart';
import '../widgets/game_button.dart';

class WifiConnectionScreen extends ConsumerWidget {
  const WifiConnectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiplayerProvider);
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(6, 6),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              GameButton(
                text: 'Host Game',
                onPressed: state.connectionState == GameConnectionState.disconnected
                    ? () {
                        ref.read(multiplayerProvider.notifier).hostGame();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WifiGameScreen(),
                          ),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Host IP',
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.accent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GameButton(
                text: 'Join Game',
                onPressed: state.connectionState == GameConnectionState.disconnected
                    ? () {
                        if (controller.text.isNotEmpty) {
                          ref
                              .read(multiplayerProvider.notifier)
                              .joinGame(controller.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WifiGameScreen(),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
