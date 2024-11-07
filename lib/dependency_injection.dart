import 'package:dio/dio.dart';
import 'package:kiwi/kiwi.dart';
import 'package:petto_app/pages/authentication/authentication_view_model.dart';
import 'package:petto_app/pages/main/main_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static final container = KiwiContainer();

  static void clear() => container.clear();

  static Future<void> setup() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    container.registerSingleton<Dio>(
      (container) => Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:8080',
        ),
      ),
    );
    container.registerSingleton(
      (container) => sharedPreferences,
    );
    container.registerFactory<MainViewModel>(
      (container) => MainViewModelImpl(
        sharedPreferences: container.resolve(),
      ),
    );
    container.registerFactory<AuthenticationViewModel>(
      (container) => AuthenticationViewModelImpl(
        httpClient: container.resolve(),
      ),
    );
  }
}
