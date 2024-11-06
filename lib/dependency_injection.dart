import 'package:kiwi/kiwi.dart';
import 'package:petto_app/pages/main/main_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static final container = KiwiContainer();

  static void clear() => container.clear();

  static Future<void> setup() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    container.registerSingleton(
      (container) => sharedPreferences,
    );
    container.registerFactory<MainViewModel>(
      (container) => MainViewModelImpl(
        sharedPreferences: container.resolve(),
      ),
    );
  }
}
