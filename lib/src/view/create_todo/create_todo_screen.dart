import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/src/misc/theme/extensions.dart';
import 'package:todo/src/misc/validators/text_input_validators.dart';
import 'package:todo/src/models/todo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'create_todo_controller.dart';

class CreateTodoScreen extends StatelessWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          TextButton(
              onPressed: Provider.of<CreateTodoController>(context).save,
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
                key: Provider.of<CreateTodoController>(context).formKey,
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
              onTap: Provider.of<CreateTodoController>(context, listen: false)
                      .canBeDeleted
                  ? () {}
                  : null,
            ),
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
    final controller =
        Provider.of<CreateTodoController>(context, listen: false);
    return Card(
      margin: EdgeInsets.zero,
      child: TextFormField(
        initialValue: controller.todo?.text,
        minLines: 4,
        maxLines: 100,
        onSaved: controller.onTextSaved,
        textCapitalization: TextCapitalization.sentences,
        validator: Validators.isNotEmpty,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: tr.whatToDo,
            contentPadding: const EdgeInsets.all(16.0)),
      ),
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
        Consumer<CreateTodoController>(builder: (context, controller, child) {
          return DropdownButton<Importance>(
            value: controller.todo?.importance,
            items: Importance.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString()),
                    ))
                .toList(),
            onChanged: controller.setImportance,
          );
        })
      ],
    );
  }
}

class DeadlineSwitch extends StatelessWidget {
  const DeadlineSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTodoController>(
        builder: (context, controller, child) {
      return SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(AppLocalizations.of(context).makeBy),
        subtitle: controller.todo?.deadline != null
            ? InkWell(
                child: Text(
                  controller.todo!.deadline!.toString(),
                ),
                onTap: () {
                  controller.pickDeadline(context);
                },
              )
            : null,
        value: controller.todo!.deadline != null,
        onChanged: (value) {
          controller.onDeadlineSwitchChanged(context, value);
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
    final redColor = Theme.of(context).extension<CustomColors>()!.red;
    final color = onTap != null ? redColor : theme.disabledColor;
    return ListTile(
      textColor: color,
      iconColor: color,
      leading: const Icon(Icons.delete),
      title: const Text("Удалить"),
      onTap: onTap,
    );
  }
}