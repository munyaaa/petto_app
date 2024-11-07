import 'package:dio/dio.dart';
import 'package:petto_app/consts/storage_keys.dart';
import 'package:petto_app/models/requests/create_pet_request_model.dart';
import 'package:petto_app/models/responses/pet_type_response_model.dart';
import 'package:petto_app/utils/page_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddPetViewModel {
  abstract BehaviorSubject<PageState<List<PetTypeResponseModel>>> petTypesState;
  abstract PublishSubject<PageState<bool>> submissionState;

  Future<void> loadPetTypes();
  Future<void> submitPet(
    CreatePetRequestModel request,
  );
}

class AddPetViewModelImpl implements AddPetViewModel {
  @override
  late BehaviorSubject<PageState<List<PetTypeResponseModel>>> petTypesState;
  @override
  late PublishSubject<PageState<bool>> submissionState;

  final Dio httpClient;
  final SharedPreferences sharedPreferences;

  AddPetViewModelImpl({
    required this.httpClient,
    required this.sharedPreferences,
  }) {
    petTypesState =
        BehaviorSubject<PageState<List<PetTypeResponseModel>>>.seeded(
      PageState.loading(),
    );
    submissionState = PublishSubject<PageState<bool>>();
  }

  @override
  Future<void> loadPetTypes() async {
    try {
      petTypesState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      final response = await httpClient.get(
        '/v1/pet_types',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      petTypesState.add(
        PageState.success(
          (response.data['data']['pet_types'] as List<dynamic>).map(
            (e) {
              return PetTypeResponseModel.fromJson(
                e as Map<String, dynamic>,
              );
            },
          ).toList(),
        ),
      );
    } on DioException catch (e) {
      petTypesState.add(
        PageState.error(
          e.response != null
              ? '${e.response?.statusCode} ${e.response?.data}'
              : e.toString(),
        ),
      );
    } catch (e) {
      petTypesState.add(
        PageState.error(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> submitPet(CreatePetRequestModel request) async {
    try {
      submissionState.add(
        PageState.loading(),
      );

      final token = sharedPreferences.getString(tokenKey);

      await httpClient.post(
        '/v1/pets',
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
}
