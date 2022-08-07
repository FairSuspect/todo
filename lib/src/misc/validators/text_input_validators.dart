abstract class Validators {
  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "Поле должно быть заполнено";
    }
    return null;
  }
}
