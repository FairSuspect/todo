import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/managers/create_todo_manager.dart';
import 'package:todo/src/misc/extensions/todo.dart';
import 'package:todo/src/misc/theme/extensions.dart';
import 'package:todo/src/misc/validators/text_input_validators.dart';
import 'package:todo/src/models/todo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTodoScreen extends StatelessWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Consumer(builder: (context, ref, child) {
      final provider = ref.read(createTodoManagerProvider);
      return WillPopScope(
        onWillPop: provider.onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: CloseButton(
              onPressed: () {
                provider.onWillPop();
              },
            ),
            actions: [
              TextButton(
                  onPressed: ref.read(createTodoManagerProvider).save,
                  child: Text(tr.save.toUpperCase())),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Form(
                        key: ref.read(createTodoManagerProvider).formKey,
                        child: child!,
                      );
                    },
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
                DeleteRow(
                  onTap: ref
                          .read(createTodoStateHolderProvider.notifier)
                          .canBeDeleted
                      ? () {}
                      : null,
                )
              ],
            ),
          ),
        ),
      );
    });
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
        final state = ref.watch(createTodoStateHolderProvider);

        return TextFormField(
          style: theme.textTheme.bodyMedium,
          initialValue: state.text,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context).importance),
        Consumer(builder: (context, ref, child) {
          final todo = ref.watch(createTodoStateHolderProvider);
          return DropdownButton<Importance>(
            underline: const SizedBox.shrink(),
            icon: const SizedBox.shrink(),
            value: todo.importance,
            items: Importance.values.map((importance) {
              return DropdownMenuItem(
                value: importance,
                child: importance == Importance.important
                    ? ImportantDropDownChild(
                        text: importance.translateImportance(context),
                      )
                    : Text(
                        importance.translateImportance(context),
                        style: Theme.of(context).textTheme.bodyMedium,
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

class DeadlineSwitch extends StatelessWidget {
  const DeadlineSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(builder: (context, ref, child) {
      final todo = ref.watch(createTodoStateHolderProvider);
      return SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(AppLocalizations.of(context).makeBy,
            style: theme.textTheme.bodyMedium),
        visualDensity: VisualDensity.standard,
        subtitle: todo.deadline != null
            ? InkWell(
                child: Text(
                  DateFormat.yMMMMd(AppLocalizations.of(context).localeName)
                      .format(todo.deadline!),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.extension<CustomColors>()?.blue),
                ),
                onTap: () {
                  ref.read(createTodoManagerProvider).pickDeadline(context);
                },
              )
            : null,
        value: todo.deadline != null,
        onChanged: (value) {
          ref
              .read(createTodoManagerProvider)
              .onDeadlineSwitchChanged(context, value);
        },
      );
    });
  }
}

class DeleteRow extends StatelessWidget {
  const DeleteRow({Key? key, this.onTap}) : super(key: key);
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final redColor = theme.errorColor;
    final color = onTap != null ? redColor : theme.disabledColor;
    return ListTile(
      textColor: color,
      iconColor: color,
      leading: const Icon(Icons.delete),
      title: Text(AppLocalizations.of(context).delete,
          style: theme.textTheme.bodyMedium?.copyWith(color: redColor)),
      onTap: onTap,
    );
  }
}
