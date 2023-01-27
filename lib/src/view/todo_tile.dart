import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/misc/theme/custom_colors.dart';
import 'package:todo/src/models/todo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodoTile extends StatelessWidget {
  const TodoTile(
      {required Key key,
      required this.todo,
      this.onChanged,
      this.onDelete,
      this.onTap})
      : super(key: key);
  final Todo todo;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onDelete;
  final GestureTapCallback? onTap;

  DateTime? get deadline => todo.deadline;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<CustomColors>()!;
    final doneStyle = theme.textTheme.bodyMedium!.merge(TextStyle(
      decoration: TextDecoration.lineThrough,
      color: theme.colorScheme.onTertiary,
    ));

    final subtitle = deadline != null
        ? Text(
            DateFormat.yMMMMd(AppLocalizations.of(context).localeName)
                .format(deadline!),
            style: theme.textTheme.titleSmall!
                .copyWith(color: theme.colorScheme.onTertiary),
          )
        : null;
    final fillColor = todo.importance == Importance.important && !todo.done
        ? MaterialStateProperty.resolveWith((states) => colors.red)
        : null;
    return Dismissible(
      key: key!,
      background: const CheckBackground(),
      secondaryBackground: const DeleteBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return true;
        }

        onChanged?.call(true);
        return false;
      },
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 14.0),
        child: ListTile(
          horizontalTitleGap: 4,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.comfortable,
          leading: Checkbox(
            fillColor: fillColor,
            value: todo.done,
            onChanged: onChanged,
            activeColor: colors.green,
          ),
          title: Row(
            children: [
              LeadingIconByImportance(importance: todo.importance),
              Expanded(
                child: Text(
                  todo.text,
                  style: todo.done ? doneStyle : theme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: subtitle,
          trailing: const Icon(Icons.info_outline),
          onTap: onTap,
        ),
      ),
    );
  }
}

class LeadingIconByImportance extends StatelessWidget {
  const LeadingIconByImportance({
    super.key,
    required this.importance,
  });
  final Importance importance;

  static const importantSvg = 'assets/svg/high_priority.svg';
  static const basicImportanceSvg = 'assets/svg/basic_priority.svg';

  @override
  Widget build(BuildContext context) {
    Widget icon;
    switch (importance) {
      case Importance.important:
        icon = SvgPicture.asset(importantSvg);
        break;
      case Importance.basic:
        icon = SvgPicture.asset(basicImportanceSvg);
        break;
      case Importance.low:
      default:
        return const SizedBox();
    }
    return Row(
      children: [
        icon,
        const SizedBox(width: 6),
      ],
    );
  }
}

class CheckBackground extends StatelessWidget {
  const CheckBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomColors>()?.green),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.check,
          size: 24,
          color: Theme.of(context).extension<CustomColors>()?.white,
        ),
      ),
    );
  }
}

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(color: theme.extension<CustomColors>()?.red),
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 24,
          color: theme.extension<CustomColors>()?.white,
        ),
      ),
    );
  }
}
