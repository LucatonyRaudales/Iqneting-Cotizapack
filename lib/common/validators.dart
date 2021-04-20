class Validators {
  static phoneValidator(value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length < 8) {
      return 'Ingresa un teléfono válido';
    }
  }

  static String? nameValidator (value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Campo obligatorio';
    }
    if (!value.contains('@')) {
      return "Tu correo debe tener '@'";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return "Ingrese un correo válido";
    }
  }

  static String? passwordValidator (value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length < 8) {
      return 'La contraseña debe contener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Z0-9a-z]*').hasMatch(value)) {
      return 'Contraseña muy débil';
    }
  }
}