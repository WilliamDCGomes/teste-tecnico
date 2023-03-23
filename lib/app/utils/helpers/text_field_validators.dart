class TextFieldValidators {
  static String? loginValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe o Nome do Usúario";
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe a Senha";
    }
    if (value.trim().length < 6) {
      return "A Senha deve conter no mínimo 6 dígitos";
    }
    return null;
  }
}