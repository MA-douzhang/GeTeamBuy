import '../../../constant/app_parameters.dart';
import '../../../constant/app_strings.dart';
import '../../../model/user_entity.dart';
import '../../../service/user_service.dart';
import '../../../utils/toast_util.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  UserService _userService = UserService();
  UserEntity? _userEntity;
  UserViewModel? _userViewModel;

  LoginViewModel(this._userViewModel);

  UserEntity? get userEntity => _userEntity;

  Future<bool> login(String account, String passWord) async {
    bool result = false;
    var parameters = {
      AppParameters.USER_NAME: account,
      AppParameters.PASS_WORD: passWord
    };
    await _userService.login(parameters).then((response) {
      if (response.isSuccess ?? false) {
        _userEntity = response.data;
        _saveUserInfo();
        _userViewModel?.setPersonInformation(
            _userEntity?.userInfo?.avatarUrl ?? '', _userEntity?.userInfo?.nickName ?? '');
        notifyListeners();
        result = true;
      } else {
        result = false;
        ToastUtil.showToast(response.message ?? '');
      }
    });
    return result;
  }

  _saveUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences
        .setString(AppStrings.TOKEN, userEntity?.token ?? '')
        .then((value) => print(value));
    await sharedPreferences.setString(
        AppStrings.HEAD_URL, userEntity?.userInfo?.avatarUrl ?? '');
    await sharedPreferences.setString(
        AppStrings.NICK_NAME, userEntity?.userInfo?.nickName ?? '');
    sharedPreferences.commit();
  }
}
