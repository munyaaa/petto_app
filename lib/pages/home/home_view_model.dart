import 'package:dio/dio.dart';
import 'package:petto_app/consts/storage_keys.dart';
import 'package:petto_app/models/responses/pet_response_model.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeViewModel {
  abstract PublishSubject<bool> logoutState;
  abstract BehaviorSubject<PageState<List<PetResponseModel>>> petListState;

  Future<void> logout();
  Future<void> loadPetList();
}

class HomeViewModelImpl implements HomeViewModel {
  @override
  late PublishSubject<bool> logoutState;

  @override
  late BehaviorSubject<PageState<List<PetResponseModel>>> petListState;

  final Dio httpClient;
  final SharedPreferences sharedPreferences;

  HomeViewModelImpl({
    required this.httpClient,
    required this.sharedPreferences,
  }) {
    logoutState = PublishSubject<bool>();
    petListState = BehaviorSubject<PageState<List<PetResponseModel>>>.seeded(
      PageState.loading(),
    );
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(tokenKey);
    logoutState.add(true);
  }

  @override
  Future<void> loadPetList() async {
    try {
      petListState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      final response = await httpClient.get(
        '/pets',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      petListState.add(
        PageState.success(
          (response.data['data']['pets'] as List<dynamic>)
              .map(
                (e) => PetResponseModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
      );
    } on DioException catch (e) {
      petListState.add(
        PageState.error(
          e.response != null
              ? '${e.response?.statusCode} ${e.response?.data}'
              : e.toString(),
        ),
      );
    } catch (e) {
      petListState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }
}
