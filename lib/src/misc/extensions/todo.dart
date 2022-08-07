import 'package:flutter/widgets.dart';
import 'package:todo/src/models/todo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TodoExtension on Importance {
  String translateImportance(BuildContext context) {
    final tr = AppLocalizations.of(context);
    switch (this) {
      case Importance.low:
        return tr.importanceNone;
      case Importance.important:
        return tr.importanceHigh;

      case Importance.basic:
      default:
        return tr.importanceBasic;
    }
  }
}
