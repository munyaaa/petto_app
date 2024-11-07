import 'package:dio/dio.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthenticationViewModel {
  abstract PublishSubject<PageState<bool>> registerState;

  Future<void> register(String username, String password);
}

class AuthenticationViewModelImpl implements AuthenticationViewModel {
  @override
  late PublishSubject<PageState<bool>> registerState;

  final Dio httpClient;

  AuthenticationViewModelImpl({
    required this.httpClient,
  }) {
    registerState = PublishSubject<PageState<bool>>();
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
}
