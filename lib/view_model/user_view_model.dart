import '../../../constant/app_parameters.dart';
import '../../../constant/app_strings.dart';
import '../../../service/mine_service.dart';
import '../../../utils/shared_preferences_util.dart';
import '../../../view_model/base_view_model.dart';

class UserViewModel extends BaseViewModel {
  MineService _mineService = MineService();
  bool _showTitle = false;
  String? _pictureUrl;
  String? _userName;
  String? _token;
  int _collectionNumber = 0;
  int _footPrintfNumber = 0;
  int _couponNumber = 0;
  int _page = 1;
  int _limit = 20;
  bool _isFirst=true;

  bool get showTitle => _showTitle;

  String? get pictureUrl => _pictureUrl;

  String? get userName => _userName;

  String? get token => _token;

  int get footPrintfNumber => _footPrintfNumber;

  int get couponNumber => _couponNumber;

  int get collectionNumber => _collectionNumber;
  String? text;

  bool get isFirst => _isFirst;

  refreshData() async {

    await SharedPreferencesUtil.getInstance()
        ?.getString(AppStrings.TOKEN)
        .then((value) => _token = value);
    if (_token != null && (_token?.isNotEmpty ??  true)) {
      await SharedPreferencesUtil.getInstance()
          ?.getString(AppStrings.NICK_NAME)
          .then((value) => _userName = value);
      await SharedPreferencesUtil.getInstance()
          ?.getString(AppStrings.HEAD_URL)
          .then((value) => _pictureUrl = value);

      await SharedPreferencesUtil.getInstance()
          ?.getBool(AppStrings.IS_FIRST)
          .then((value) {
        _isFirst = value ??= true;
      });
      await _queryCoupon();
      await _queryFootPrint();
      await _queryCollection();
      notifyListeners();
    }
  }

  _queryCoupon() async {
    var couponParameters = {
      AppParameters.PAGE: _page,
      AppParameters.LIMIT: _limit
    };
    await _mineService
        .queryCoupon(couponParameters)
        .then((value) => _couponNumber = value.data?.total ?? 0);
  }

  _queryCollection() async {
    var collectionParameters = {
      AppParameters.TYPE: 0,
      AppParameters.PAGE: 1,
      AppParameters.LIMIT: 1000
    };

    await _mineService
        .queryCollect(collectionParameters)
        .then((value) => _collectionNumber = value.data?.total ?? 0);
  }

  _queryFootPrint() async {
    var footPrintParameters = {
      AppParameters.PAGE: _page,
      AppParameters.LIMIT: _limit
    };
    await _mineService
        .queryFootPrint(footPrintParameters)
        .then((value) => _footPrintfNumber = value.data.total);
  }

  collectionDataChange() {
    _queryCollection();
    notifyListeners();
  }

  footPrintDataChange() {
    _queryFootPrint();
  }

  setShowTitle(bool value) {
    _showTitle = value;
    notifyListeners();
  }

  setPersonInformation(String pictureUrl, String userName) {
    _pictureUrl = pictureUrl;
    _userName = userName;
  }
}
