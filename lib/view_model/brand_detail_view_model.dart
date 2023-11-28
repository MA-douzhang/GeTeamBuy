import '../../../constant/app_parameters.dart';
import '../../../model/brand_detail_entity.dart';
import '../../../service/brand_detail_service.dart';
import '../../../utils/toast_util.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/page_state.dart';

class BrandDetailViewModel extends BaseViewModel {
  BrandDetailService _brandDetailService = BrandDetailService();
  BrandDetailEntity? _brandDetialEntity;

  BrandDetailEntity? get brandDetialEntity => _brandDetialEntity;

  queryBrandDetail(int id) {
    var parmeters = {AppParameters.ID: id};
    _brandDetailService.queryBrandDetail(parmeters).then((response) {
      if (response.isSuccess ?? false) {
        _brandDetialEntity = response.data;
        pageState = PageState.hasData;
        notifyListeners();
      } else {
        ToastUtil.showToast(response?.message ?? '');
      }
    });
  }
}
