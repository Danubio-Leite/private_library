import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<bool> isFirstAccess() async {
    try {
      DateTime start = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime end = DateTime.now();
      print(
          'SharedPreferences.getInstance() levou ${end.difference(start).inMilliseconds}ms');

      bool isFirstAccess = prefs.getBool('isFirstAccess') ?? true;
      return isFirstAccess;
    } catch (e) {
      print("Erro ao acessar SharedPreferences: $e");
      // Retorne um valor padrão ou rethrow a exceção
      return true;
    }
  }

  Future<void> setFirstAccess() async {
    try {
      DateTime start = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime end = DateTime.now();
      print(
          'SharedPreferences.getInstance() levou ${end.difference(start).inMilliseconds}ms');

      await prefs.setBool('isFirstAccess', false);
    } catch (e) {
      print("Erro ao definir SharedPreferences: $e");
      // Rethrow a exceção ou lidar com ela de outra maneira
      throw e;
    }
  }
}
