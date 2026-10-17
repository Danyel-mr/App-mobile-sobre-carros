import 'package:s_car/usuario.dart';

// Login simplificado: não há usuário nem senha.
// Ao tocar no botão de login o próprio app fornece o usuário.
class Autenticador {
  static Future<Usuario?> login() async {
    return Usuario("Carlos Andrade", "carlos.andrade@s-car.com");
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario("Carlos Andrade", "carlos.andrade@s-car.com");
  }

  static Future<void> logout() async {
    //
  }
}
