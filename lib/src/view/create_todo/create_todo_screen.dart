import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/managers/create_todo_manager.dart';
import 'package:todo/src/managers/todo_list_manager.dart';
import 'package:todo/src/misc/extensions/todo.dart';
import 'package:todo/src/misc/theme/extensions.dart';
import 'package:todo/src/misc/validators/text_input_validators.dart';
import 'package:todo/src/models/todo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTodoScreen extends ConsumerStatefulWidget {
  const CreateTodoScreen({super.key, required this.todoId});
  final String? todoId;

  @override
  ConsumerState<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends ConsumerState<CreateTodoScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.todoId != null) {
      final todo = ref.read(createTodoStateHolderProvider);
      if (todo.isBlank || todo.id != widget.todoId) {
        ref.read(createTodoManagerProvider).getTodo(widget.todoId!);
      }
    } else {
      Future(() => ref.read(createTodoManagerProvider).setActiveTodo(null));
    }
  }

  @override
  void dispose() {
    // ref.read(createTodoStateHolderProvider.notifier).textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          TextButton(
              onPressed: () {
                // Пытался вынести логику отсюда в дополнительный провайдер
                // Но не смог придумать как получать туду после сохранения
                if (ref
                    .read(createTodoManagerProvider)
                    .formKey
                    .currentState!
                    .validate()) {
                  ref.read(createTodoManagerProvider).save();
                  final todo = ref.read(createTodoStateHolderProvider);
                  if (todo.createdAt == null) {
                    ref.read(todoListManagerProvider).createTodo(todo);
                  } else {
                    ref.read(todoListManagerProvider).updateTodo(todo);
                  }
                }
              },
              child: Text(tr.save.toUpperCase())),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Form(
                key: ref.read(createTodoManagerProvider).formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TextField(),
                    SizedBox(height: 8),
                    ImportanceSelector(),
                    Divider(),
                    DeadlineSwitch(),
                  ],
                ),
              ),
            ),
            const Divider(),
            const DeleteRow()
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(createTodoStateHolderProvider.notifier);

        return TextFormField(
          style: theme.textTheme.bodyMedium,
          controller: state.textController,
          minLines: 4,
          maxLines: 100,
          onSaved: ref.read(createTodoManagerProvider).onTextSaved,
          textCapitalization: TextCapitalization.sentences,
          validator: Validators.isNotEmpty,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: tr.whatToDo,
              contentPadding: const EdgeInsets.all(16.0)),
        );
      }),
    );
  }
}

class ImportanceSelector extends StatelessWidget {
  const ImportanceSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context).importance),
        Consumer(builder: (context, ref, child) {
          final importance = ref.watch(createTodoStateHolderProvider
              .select((value) => value.importance));
          return DropdownButton<Importance>(
            underline: const SizedBox.shrink(),
            icon: const SizedBox.shrink(),
            value: importance,
            selectedItemBuilder: (BuildContext context) {
              return Importance.values.map((importance) {
                return Center(
                  child: importance == Importance.important
                      ? ImportantDropDownChild(
                          text: importance.translateImportance(context),
                        )
                      : Text(
                          importance.translateImportance(context),
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.onTertiary),
                        ),
                );
              }).toList();
            },
            items: Importance.values.map((importance) {
              return DropdownMenuItem(
                value: importance,
                child: importance == Importance.important
                    ? ImportantDropDownChild(
                        text: importance.translateImportance(context),
                      )
                    : Text(
                        importance.translateImportance(context),
                        style: theme.textTheme.bodyMedium,
                      ),
              );
            }).toList(),
            onChanged: ref.read(createTodoManagerProvider).setImportance,
          );
        })
      ],
    );
  }
}

class ImportantDropDownChild extends StatelessWidget {
  const ImportantDropDownChild({Key? key, required this.text})
      : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "!! $text",
      style: theme.textTheme.bodyMedium
          ?.copyWith(color: Theme.of(context).extension<CustomColors>()?.red),
    );
  }
}

class DeadlineSwitch extends ConsumerWidget {
  const DeadlineSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final deadline = ref
        .watch(createTodoStateHolderProvider.select((todo) => todo.deadline));
    return SwitchListTile(
      inactiveThumbColor: theme.canvasColor,
      inactiveTrackColor: theme.extension<LayoutColors>()?.overlayColor,
      contentPadding: EdgeInsets.zero,
      title: Text(AppLocalizations.of(context).makeBy,
          style: theme.textTheme.bodyMedium),
      visualDensity: VisualDensity.standard,
      subtitle: deadline != null
          ? InkWell(
              child: Text(
                DateFormat.yMMMMd(AppLocalizations.of(context).localeName)
                    .format(deadline),
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.extension<CustomColors>()?.blue),
              ),
              onTap: () {
                ref.read(createTodoManagerProvider).pickDeadline(context);
              },
            )
          : null,
      value: deadline != null,
      onChanged: (value) {
        ref
            .read(createTodoManagerProvider)
            .onDeadlineSwitchChanged(context, value);
      },
    );
  }
}

class DeleteRow extends ConsumerWidget {
  const DeleteRow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final redColor = theme.errorColor;
    final available = ref.watch(
            createTodoStateHolderProvider.select((value) => value.createdAt)) !=
        null;

    final color = available ? redColor : theme.disabledColor;
    return ListTile(
      textColor: color,
      iconColor: color,
      leading: const Icon(Icons.delete),
      title: Text(AppLocalizations.of(context).delete,
          style: theme.textTheme.bodyMedium?.copyWith(color: color)),
      onTap: available
          ? () {
              ref.read(createTodoManagerProvider).onDeleteTap();
              ref
                  .read(todoListManagerProvider)
                  .delete(ref.read(createTodoStateHolderProvider).id);
            }
          : null,
    );
  }
}
