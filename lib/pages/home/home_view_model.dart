import 'package:dio/dio.dart';
import 'package:petto_app/consts/storage_keys.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeViewModel {
  abstract PublishSubject<bool> logoutState;

  Future<void> logout();
}

class HomeViewModelImpl implements HomeViewModel {
  @override
  late PublishSubject<bool> logoutState;

  final Dio httpClient;
  final SharedPreferences sharedPreferences;

  HomeViewModelImpl({
    required this.httpClient,
    required this.sharedPreferences,
  }) {
    logoutState = PublishSubject<bool>();
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(tokenKey);
    logoutState.add(true);
  }
}
