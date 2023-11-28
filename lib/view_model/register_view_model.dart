import '../../../constant/app_strings.dart';
import '../../../service/user_service.dart';
import '../../../constant/app_parameters.dart';
import '../../../utils/toast_util.dart';
import '../../../view_model/base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  UserService _userService = UserService();

  Future<bool> register(String account, String passWord) async {
    var parameters = {
      AppParameters.USER_NAME: account,
      AppParameters.PASS_WORD: passWord,
      AppParameters.MOBILE: account,
      AppParameters.CODE: "8888"
    };
    bool result = false;
    await _userService.register(parameters).then((response) {
      if (response.isSuccess ?? false) {
        result = true;
      } else {
        ToastUtil.showToast(response.message ?? '');
        result = false;
      }
    });
    return result;
  }
}
