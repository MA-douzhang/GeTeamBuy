import '../../../constant/app_parameters.dart';
import '../../../model/goods_entity.dart';
import '../../../model/search_goods_entity.dart';
import '../../../service/goods_service.dart';
import '../../../utils/toast_util.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/page_state.dart';

class SearchGoodsViewModel extends BaseViewModel {
  GoodsService _goodsService = GoodsService();
  SearchGoodsEntity? _goodsEntity;
  List<GoodsEntity>? _goods = [];
  bool _publishTimeConditionArrowUp = false;
  bool _priceConditionArrowUp = false;
  bool _isLoadMore = false;

  bool get isLoadMore => _isLoadMore;

  bool get publishTimeConditionArrowUp => _publishTimeConditionArrowUp;

  bool get priceConditionArrowUp => _priceConditionArrowUp;

  SearchGoodsEntity? get goodsEntity => _goodsEntity;

  List<GoodsEntity>? get goods => _goods;

  setPublicTimeCondition(bool isUp) {
    _publishTimeConditionArrowUp = isUp;
    notifyListeners();
  }

  setPriceCondition() {
    _priceConditionArrowUp = !_priceConditionArrowUp;
    print(_priceConditionArrowUp);
    notifyListeners();
  }

  setPublishTimeCondition() {
    _publishTimeConditionArrowUp = !_publishTimeConditionArrowUp;
    notifyListeners();
  }

  Future<bool> searchGoods(String keyword, int pageIndex, int limit,
      String sortName, String orderType) async {
    var parameters = {
      AppParameters.KEYWORD: keyword,
      AppParameters.PAGE: pageIndex,
      AppParameters.LIMIT: limit,
      AppParameters.SORT: sortName,
      AppParameters.ORDER: orderType
    };
    await _goodsService.searchGoods(parameters).then((response) {
      if (response.isSuccess ?? false) {
        _goodsEntity = response.data;
        if (pageIndex == 1) {
          _goods?.clear();
          _goods = response.data?.xList;
        } else {
          _goods?.addAll(response?.data?.xList ?? []);
        }
        pageState = _goods?.length == 0 ? PageState.empty : PageState.hasData;
        _isLoadMore = (response.data?.total ?? 0) > (_goodsEntity?.xList?.length ?? 0);
        print(_goods?.length);
        notifyListeners();
      } else {
        if (pageIndex == 1) {
          pageState = PageState.error;
        }
        ToastUtil.showToast(response.message ?? '');
        notifyListeners();
      }
    });
    return true;
  }
}
