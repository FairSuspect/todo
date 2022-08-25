import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/managers/todo_list_manager.dart';
import 'package:todo/src/view/list_todo/todo_list_base_controller.dart';

class AppBarDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String subtitle;

  AppBarDelegate({
    required this.title,
    required this.subtitle,
  });

  /// Левый край, дальше которого текст не будет смещаться
  static const double _leftEnd = 16.0;

  static const double _bottomLimit = 16.0;

  static const double _bottomStart = 44.0;

  static const double _leftStart = 60;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).backgroundColor,
      elevation: lerpDouble(0.0, 4.0, shrinkOffset / maxExtent) ?? 0,
      child: LayoutBuilder(builder: (context, constraints) {
        final double ratio = shrinkOffset + minExtent < maxExtent
            ? (shrinkOffset +
                    lerpDouble(0, minExtent, shrinkOffset / maxExtent)!) /
                maxExtent
            : 1;

        /// Смешение текста по оси x
        final double? leftShift = lerpDouble(_leftEnd, _leftStart, 1 - ratio);

        /// Смещение текста по оси y
        final double? bottomShift =
            lerpDouble(_bottomStart, _bottomLimit, ratio);
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            // Заголовок
            Positioned(
              left: leftShift,
              bottom: bottomShift,
              // top: topShift,
              child: Text(title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize:
                          lerpDouble(minFontSize, maxFontSize, 1 - ratio))),
            ),
            // Текст "Выполнено - {count}"
            Consumer(builder: (context, ref, child) {
              final todos = ref.watch(todoListStateProvider);
              final theme = Theme.of(context);
              return Positioned(
                left: leftShift,
                bottom: 18,
                child: Opacity(
                  opacity: lerpDouble(1, 0.0, ratio) ?? 0,
                  child: Text(
                      "$subtitle — ${todos.entries.where((element) => element.value.done).length}",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onTertiary)),
                ),
              );
            }),
            // Переключатель фильтра задач
            Consumer(builder: (context, ref, child) {
              final isFilterOn = ref.watch(filterProvider);
              return Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                  icon: isFilterOn
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: ref.read(filterManagerProvider).onChecked,
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  double get minFontSize => 20.0;
  double get maxFontSize => 32.0;

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.green,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: const Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: const FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
