import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:todo/src/managers/create_todo_manager.dart';
import 'package:todo/src/managers/todo_list_manager.dart';
import 'package:todo/src/misc/theme/custom_colors.dart';
import 'package:todo/src/view/add_todo_tile.dart';
import 'package:todo/src/view/todo_tile.dart';

import 'app_bar.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Consumer(builder: (context, ref, child) {
        final todos = ref.watch(filteredTodosProvider);
        final controller = ref.read(todoListManagerProvider);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: AppBarDelegate(
                    title: locale.myTasks, subtitle: locale.done),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverClip(
                  child: SliverStack(
                    insetOnOverlap: false,
                    children: [
                      const SliverPositioned.fill(
                          child: Card(
                        margin: EdgeInsets.zero,
                      )),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) {
                            if (index == todos.length) {
                              return AddTodoTile(
                                  onSubmitted: controller.createTodoFromText);
                            }
                            final id = todos.keys.toList()[index];

                            return TodoTile(
                                key: ValueKey(todos[id]!.id),
                                todo: todos[id]!,
                                onChanged: (value) {
                                  controller.onChecked(todos[id]!.id, value);
                                },
                                onDelete: () {
                                  controller.delete(todos[id]!.id);
                                },
                                onTap: () {
                                  controller.onTodoSelected(todos[id]!);
                                  ref
                                      .read(createTodoManagerProvider)
                                      .setActiveTodo(todos[id]!);
                                });
                          },
                          childCount: todos.length + 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.onFABPressed,
            child: Icon(
              Icons.add,
              color: theme.extension<CustomColors>()!.white,
            ),
          ),
        );
      }),
    );
  }
}
