// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranch_components/ranch_components.dart';
import 'package:very_good_ranch/game/entities/food/behaviors/draggable_behavior.dart';
import 'package:very_good_ranch/game/entities/food/food.dart';

import '../../../../helpers/helpers.dart';

void main() {
  final flameTester = FlameTester(TestGame.new);

  group('DraggableBehavior', () {
    flameTester.testGameWidget(
      'is draggable',
      setUp: (game, tester) async {
        final food = Food.test(behaviors: [DraggableBehavior()]);
        await game.ensureAdd(food);
        await game.ready();
      },
      verify: (game, tester) async {
        await tester.dragFrom(
          Offset.zero,
          const Offset(100, 100),
        );
        await tester.pump();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/draggable/dragged.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'only drags one food item',
      setUp: (game, tester) async {
        final food1 = Food.test(behaviors: [DraggableBehavior()]);

        final food2 = Food.test(
          type: FoodType.iceCream,
          behaviors: [DraggableBehavior()],
        );

        await game.ensureAdd(food1);
        await game.ensureAdd(food2);
      },
      verify: (game, tester) async {
        await tester.dragFrom(
          Offset.zero,
          const Offset(100, 100),
        );
        await tester.pump();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile(
            'golden/draggable/single_item_dragged.png',
          ),
        );
      },
    );
  });
}