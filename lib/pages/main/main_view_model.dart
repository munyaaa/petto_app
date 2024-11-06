import 'package:petto_app/consts/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainViewModel {
  bool isLogin();
}

class MainViewModelImpl implements MainViewModel {
  final SharedPreferences sharedPreferences;

  MainViewModelImpl({
    required this.sharedPreferences,
  });

  @override
  bool isLogin() {
    return (sharedPreferences.getString(tokenKey) ?? '').isNotEmpty;
  }
}
