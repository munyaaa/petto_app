import 'package:dio/dio.dart';
import 'package:petto_app/consts/storage_keys.dart';
import 'package:petto_app/models/requests/update_pet_request_model.dart';
import 'package:petto_app/models/responses/pet_detail_response_model.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PetDetailViewModel {
  abstract BehaviorSubject<PageState<PetDetailResponseModel>> petDetailState;
  abstract PublishSubject<PageState<bool>> submissionState;

  Future<void> loadPetDetail(int id);
  Future<void> updatePet(
    int id, {
    required UpdatePetRequestModel request,
  });
  Future<void> deletePet(int id);
}

class PetDetailViewModelImpl implements PetDetailViewModel {
  @override
  late BehaviorSubject<PageState<PetDetailResponseModel>> petDetailState;
  @override
  late PublishSubject<PageState<bool>> submissionState;

  final Dio httpClient;
  final SharedPreferences sharedPreferences;

  PetDetailViewModelImpl({
    required this.httpClient,
    required this.sharedPreferences,
  }) {
    petDetailState = BehaviorSubject<PageState<PetDetailResponseModel>>.seeded(
      PageState.loading(),
    );
    submissionState = PublishSubject<PageState<bool>>();
  }

  @override
  Future<void> loadPetDetail(int id) async {
    try {
      petDetailState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      final response = await httpClient.get(
        '/pets/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      petDetailState.add(
        PageState.success(
          PetDetailResponseModel.fromJson(
            response.data['data'],
          ),
        ),
      );
    } on DioException catch (e) {
      petDetailState.add(
        PageState.error(
          e.response != null
              ? '${e.response?.statusCode} ${e.response?.data}'
              : e.toString(),
        ),
      );
    } catch (e) {
      petDetailState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> updatePet(
    int id, {
    required UpdatePetRequestModel request,
  }) async {
    try {
      submissionState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      await httpClient.put(
        '/pets/$id',
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      submissionState.add(
        PageState.success(true),
      );
    } on DioException catch (e) {
      submissionState.add(
        PageState.error(
          e.response != null
              ? '${e.response?.statusCode} ${e.response?.data}'
              : e.toString(),
        ),
      );
    } catch (e) {
      submissionState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> deletePet(int id) async {
    try {
      submissionState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      await httpClient.delete(
        '/pets/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      submissionState.add(
        PageState.success(true),
      );
    } on DioException catch (e) {
      submissionState.add(
        PageState.error(
          e.response != null
              ? '${e.response?.statusCode} ${e.response?.data}'
              : e.toString(),
        ),
      );
    } catch (e) {
      submissionState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }
}
