import '../../../constant/app_parameters.dart';
import '../../../model/home_entity.dart';
import '../../../service/home_service.dart';
import '../../../service/mine_service.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/page_state.dart';

class TabHomeViewModel extends BaseViewModel {
  HomeService _homeService = HomeService();
  MineService _mineService = MineService();
  HomeEntity? homeModelEntity;

  void loadTabHomeData() {
    _homeService.queryHomeData().then((response) {
      if (response.isSuccess ?? false) {
        homeModelEntity = response.data;
        pageState =
            homeModelEntity == null ? PageState.empty : PageState.hasData;
        print(homeModelEntity?.couponList?.length);
        notifyListeners();
      }
    }, onError: (errorMessage) {
      pageState = PageState.error;
      notifyListeners();
    });
  }

  Future<bool?> receiveCoupon(int couponId) async {
    var parameters = {AppParameters.COUPON_ID: couponId};
    await _mineService.receiveCoupon(parameters).then((response) {
      return response.isSuccess;
    });
  }
}
