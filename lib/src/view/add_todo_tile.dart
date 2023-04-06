import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Виджет для добавления задачи из строки
/// При нажатии на done а клавиатуре срабатывает коллбек [onSubmitted]
/// При сворачивании клавиатуры пока не срабатывает, так как фокус не теряется
class AddTodoTile extends StatelessWidget {
  const AddTodoTile({super.key, required this.onSubmitted});

  final ValueChanged<String> onSubmitted;
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 0),
        leading: const SizedBox.shrink(),
        title: TextFormField(
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: tr.newTask,
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onTertiary,
            ),
          ),
          onFieldSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          maxLines: 1,
        ),
      ),
    );
  }
}
