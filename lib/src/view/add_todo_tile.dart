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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.add),
        title: TextFormField(
          decoration: InputDecoration(hintText: tr.newTask),
          onFieldSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          maxLines: 1,
        ),
      ),
    );
  }
}
