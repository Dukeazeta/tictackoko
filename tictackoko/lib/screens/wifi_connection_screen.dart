import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/multiplayer_provider.dart';
import '../utils/constants.dart';
import 'wifi_game_screen.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(200, 50),
                ),
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
                child: const Text('Host Game',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter Host IP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(200, 50),
                ),
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
                child: const Text('Join Game',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
