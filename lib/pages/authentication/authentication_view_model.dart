import 'package:dio/dio.dart';
import 'package:petto_app/consts/storage_keys.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationViewModel {
  abstract PublishSubject<PageState<bool>> registerState;
  abstract PublishSubject<PageState<bool>> loginState;

  Future<void> register(String username, String password);
  Future<void> login(String username, String password);
}

class AuthenticationViewModelImpl implements AuthenticationViewModel {
  @override
  late PublishSubject<PageState<bool>> registerState;

  @override
  late PublishSubject<PageState<bool>> loginState;

  final Dio httpClient;
  final SharedPreferences sharedPreferences;

  AuthenticationViewModelImpl({
    required this.httpClient,
    required this.sharedPreferences,
  }) {
    registerState = PublishSubject<PageState<bool>>();
    loginState = PublishSubject<PageState<bool>>();
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      registerState.add(
        PageState.loading(),
      );

      await httpClient.post(
        '/v1/auth/register',
        data: {
          'username': username,
          'password': password,
        },
      );

      registerState.add(
        PageState.success(true),
      );
    } on DioException catch (e) {
      registerState.add(
        PageState.error(
          e.response?.data ?? e.toString(),
        ),
      );
    } catch (e) {
      registerState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> login(String username, String password) async {
    try {
      loginState.add(
        PageState.loading(),
      );

      final response = await httpClient.post(
        '/v1/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      await sharedPreferences.setString(
        tokenKey,
        response.data['data']['token'],
      );

      loginState.add(
        PageState.success(true),
      );
    } on DioException catch (e) {
      loginState.add(
        PageState.error(
          e.response?.data ?? e.toString(),
        ),
      );
    } catch (e) {
      loginState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }
}
