import 'package:dio/dio.dart';
import 'package:kiwi/kiwi.dart';
import 'package:petto_app/pages/add_pet/add_pet_view_model.dart';
import 'package:petto_app/pages/authentication/authentication_view_model.dart';
import 'package:petto_app/pages/home/home_view_model.dart';
import 'package:petto_app/pages/main/main_view_model.dart';
import 'package:petto_app/pages/pet_detail/pet_detail_view_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static final container = KiwiContainer();

  static void clear() => container.clear();

  static Future<void> setup() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    container.registerSingleton<Dio>(
      (container) => Dio(
        BaseOptions(
          // You also can try this url: [https://petto-api.fly.dev]
          baseUrl: 'http://10.0.2.2:8080',
        ),
      )..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
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
        sharedPreferences: container.resolve(),
      ),
    );
    container.registerFactory<HomeViewModel>(
      (container) => HomeViewModelImpl(
        httpClient: container.resolve(),
        sharedPreferences: container.resolve(),
      ),
    );
    container.registerFactory<AddPetViewModel>(
      (container) => AddPetViewModelImpl(
        httpClient: container.resolve(),
        sharedPreferences: container.resolve(),
      ),
    );
    container.registerFactory<PetDetailViewModel>(
      (container) => PetDetailViewModelImpl(
        httpClient: container.resolve(),
        sharedPreferences: container.resolve(),
      ),
    );
  }
}
