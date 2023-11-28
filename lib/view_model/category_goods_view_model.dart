import 'package:ge_team_buy/view_model/page_state.dart';

import '../constant/app_parameters.dart';
import '../model/category_goods_entity.dart';
import '../model/category_title_entity.dart';
import '../model/goods_entity.dart';
import '../service/category_service.dart';
import '../service/goods_service.dart';
import '../utils/toast_util.dart';
import 'base_view_model.dart';

class CategoryGoodsViewModel extends BaseViewModel {
  GoodsService _goodsService = GoodsService();
  CategoryService _categoryService = CategoryService();
  CategoryTitleEntity? _categoryTitleEntity;
  CategoryGoodsEntity? _categoryGoodsEntity;
  bool _canLoadMore = false;
  List<GoodsEntity> _goods  = [];

  List<GoodsEntity> get goods => _goods;

  CategoryTitleEntity? get categoryTitleEntity => _categoryTitleEntity;

  bool get canLoadMore => _canLoadMore;

  CategoryGoodsEntity? get categoryGoodsEntity => _categoryGoodsEntity;

  void queryCategoryGoods(int categoryId, int pageIndex, int limit) {
    var parameters = {
      AppParameters.CATEGORY_ID: categoryId,
      AppParameters.PAGE: pageIndex,
      AppParameters.LIMIT: limit
    };
    _goodsService.getCategoryGoodsData(parameters).then((response) {
      if (response.isSuccess ??  false) {
        _categoryGoodsEntity = response.data;
        if (pageIndex == 1) {
          _goods.clear();
          _goods = response?.data?.xList ?? [];
        } else {
          _goods.addAll(response.data?.xList ?? []);
        }
        pageState = _goods.length == 0 ? PageState.empty : PageState.hasData;
        _canLoadMore = (response.data?.total ?? 0) > _goods.length;
        notifyListeners();
      } else {
        errorNotify(response.message ?? '');
      }
    });
  }

  void queryCategoryName(int categoryId) {
    var parameters = {
      AppParameters.ID: categoryId,
    };
    _categoryService.getCategoryTitle(parameters).then((response) {
      if (response.isSuccess ?? false) {
        _categoryTitleEntity = response.data;
        notifyListeners();
      } else {
        ToastUtil.showToast(response.message ?? '');
      }
    });
  }
}
