import 'dart:ui';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:sharezone_about_page_addon/game/horizon/horizon.dart';
import 'package:sharezone_about_page_addon/game/collision/collision_utils.dart';
import 'package:sharezone_about_page_addon/game/game_config.dart';
import 'package:sharezone_about_page_addon/game/game_over/game_over.dart';
import 'package:sharezone_about_page_addon/game/t_rex/config.dart';
import 'package:sharezone_about_page_addon/game/t_rex/t_rex.dart';

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame
    with HasTapableComponents, MultiTouchTapDetector {
  TRexGame({Image spriteImage}) {
    tRex = TRex(spriteImage);
    horizon = Horizon(spriteImage);
    gameOverPanel = GameOverPanel(spriteImage);

    this..add(horizon)..add(tRex)..add(gameOverPanel);
  }

  TRex tRex;
  Horizon horizon;
  GameOverPanel gameOverPanel;
  TRexGameStatus status = TRexGameStatus.waiting;

  double currentSpeed = GameConfig.speed;
  material.ValueNotifier<double> timePlaying = material.ValueNotifier(0.0);

  @override
  void update(double t) {
    tRex.update(t);
    horizon.updateWithSpeed(0.0, currentSpeed);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= TRexConfig.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {
      horizon.updateWithSpeed(0.0, currentSpeed);
    }

    if (playing) {
      timePlaying.value = timePlaying.value + t;
      horizon.updateWithSpeed(t, currentSpeed);

      final obstacles = horizon.horizonLine.obstacleManager.components;
      final hasCollision =
          obstacles.isNotEmpty && checkForCollision(obstacles.first, tRex);
      if (!hasCollision) {
        if (currentSpeed < GameConfig.maxSpeed) {
          currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
  }

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  void doGameOver() {
    gameOverPanel.visible = true;
    stop();
    tRex.status = TRexStatus.crashed;
  }

  void stop() {
    status = TRexGameStatus.gameOver;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    timePlaying.value = 0.0;
  }

  @override
  void onTapDown(int pointerId, material.TapDownDetails details) {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(currentSpeed);
  }
}
