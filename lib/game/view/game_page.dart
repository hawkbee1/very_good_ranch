import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ranch_flame/ranch_flame.dart';
import 'package:ranch_sounds/ranch_sounds.dart';
import 'package:very_good_ranch/app/view/game_viewport.dart';
import 'package:very_good_ranch/game/game.dart';
import 'package:very_good_ranch/loading/loading.dart';
import 'package:very_good_ranch/settings/bloc/bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    this.game,
  });

  final FlameGame? game;

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => const GamePage(),
    );
  }

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  FlameGame? _game;

  late UnprefixedImages preloadedImages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve preloaded images
    preloadedImages = context.read<PreloadCubit>().images;
  }

  @override
  Widget build(BuildContext context) {
    _game ??= widget.game ??
        VeryGoodRanchGame(
          blessingBloc: context.read<BlessingBloc>(),
          images: preloadedImages,
          viewPadding: MediaQuery.of(context).viewPadding,
        );

    return BackgroundSoundWidget(
      ranchSound: RanchSound.mitchelRanch,
      player: context.read<PreloadCubit>().sounds,
      volume: context.watch<SettingsBloc>().state.musicVolume,
      child: GameViewport(
        child: Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF46B2A0),
                  Color(0xFF92DED3),
                  Color(0xFF92DED3),
                  Color(0xFF46B2A0),
                ],
                stops: [
                  0.0,
                  0.15,
                  0.85,
                  1.0,
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: GameView(game: _game!),
                ),
                FooterWidget(game: _game!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
