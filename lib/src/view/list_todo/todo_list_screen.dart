import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:todo/src/misc/theme/custom_colors.dart';
import 'package:todo/src/view/add_todo_tile.dart';
import 'package:todo/src/view/todo_tile.dart';

import 'app_bar.dart';
import 'todo_list_base_controller.dart';

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
      child: Consumer<TodoListBaseController>(
          builder: (context, controller, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                // floating: true,

                delegate: AppBarDelegate(
                    title: locale.myTasks, subtitle: locale.done),
                // delegate: MySliverAppBar(expandedHeight: 200),
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
                            if (index == controller.filteredTodos.length) {
                              return AddTodoTile(
                                  onSubmitted: controller.createTodoFromText);
                            }
                            return TodoTile(
                                key: ValueKey(
                                    controller.filteredTodos[index].id),
                                todo: controller.filteredTodos[index],
                                onChanged: (value) {
                                  controller.onChecked(index, value);
                                },
                                onDelete: () {
                                  controller.onDelete(index);
                                },
                                onTap: () {
                                  controller.onTodoSelected(index);
                                });
                          },
                          childCount: controller.filteredTodos.length + 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ListView.builder(
          //   itemCount: controller.todos.length,
          //   itemBuilder: (context, index) {
          //     return TodoTile(
          //         key: ValueKey(controller.todos[index].id),
          //         todo: controller.todos[index],
          //         onChanged: (value) {
          //           controller.onChecked(index, value);
          //         },
          //         onDelete: () {
          //           controller.onDelete(index);
          //         },
          //         onTap: () {
          //           controller.onTodoSelected(index);
          //         });
          //   },
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.onPressed,
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
