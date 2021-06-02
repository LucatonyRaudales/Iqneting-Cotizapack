class Validators {
  static String? phoneValidator(String? value) {
    if (value!.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length < 8) {
      return 'Ingresa un teléfono válido';
    }
  }

  static String? nameValidator(value) {
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

  static String? passwordValidator(value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length < 8) {
      return 'Debe contener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Z0-9a-z]*').hasMatch(value)) {
      return 'Contraseña muy débil';
    }
  }

  static String? addressValidator(value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length < 10) {
      return "ingrese una dirección más exacta";
    }
  }

  static String? urlValidator(value) {
    if (!Uri.parse(value).isAbsolute) {
      return 'ingrese un link de pago válido';
    }
  }
}
