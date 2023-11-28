
import '../constant/app_strings.dart';
import '../constant/app_urls.dart';
import '../model/category_goods_entity.dart';
import '../model/goods_detail_entity.dart';
import '../model/json_result.dart';
import '../model/search_goods_entity.dart';
import '../utils/http_util.dart';

class GoodsService {
  //获取分类下的商品信息
  Future<JsonResult<CategoryGoodsEntity>> getCategoryGoodsData(
      Map<String, dynamic> parameters) async {
    JsonResult<CategoryGoodsEntity> jsonResult =
        JsonResult<CategoryGoodsEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.GOODS_LIST_URL, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        CategoryGoodsEntity categoryGoodsEntity =
            CategoryGoodsEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.isSuccess = true;
        jsonResult.data = categoryGoodsEntity;
      } else {
        jsonResult.isSuccess = false;
        jsonResult.message = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.isSuccess = false;
      jsonResult.message = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //获取商品详情
  Future<JsonResult<GoodsDetailEntity>> getGoodsDetailData(
      Map<String, dynamic> parameters) async {
    JsonResult<GoodsDetailEntity> jsonResult = JsonResult<GoodsDetailEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.GOODS_DETAILS_URL, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        GoodsDetailEntity goodsDetailEntity =
            GoodsDetailEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.isSuccess = true;
        jsonResult.data = goodsDetailEntity;
      } else {
        jsonResult.isSuccess = false;
        jsonResult.message = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.isSuccess = false;
      jsonResult.message = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //快速购买
  Future<JsonResult<dynamic>> buy(Map<String, dynamic> parameters) async {
    JsonResult<dynamic> jsonResult = JsonResult<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.FAST_BUY,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        jsonResult.isSuccess = true;
        jsonResult.data = response[AppStrings.DATA];
      } else {
        jsonResult.isSuccess = false;
        jsonResult.message = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.isSuccess = false;
      jsonResult.message = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //提交订单
  Future<JsonResult<dynamic>> submitOrder(
      Map<String, dynamic> parameters) async {
    JsonResult<dynamic> jsonResult = JsonResult<dynamic>();
    try {
      var response = await HttpUtil.instance
          .post(AppUrls.SUBMIT_ORDER, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        jsonResult.isSuccess = true;
      } else {
        jsonResult.isSuccess = false;
        jsonResult.message = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.isSuccess = false;
      jsonResult.message = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //商品搜素
  Future<JsonResult<SearchGoodsEntity>> searchGoods(
      Map<String, dynamic> parameters) async {
    JsonResult<SearchGoodsEntity> jsonResult = JsonResult<SearchGoodsEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.GOODS_LIST_URL, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        SearchGoodsEntity searchGoodsEntity =
            SearchGoodsEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.isSuccess = true;
        jsonResult.data = searchGoodsEntity;
      } else {
        jsonResult.isSuccess = false;
        jsonResult.message = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.isSuccess = false;
      jsonResult.message = AppStrings.SERVER_EXCEPTION;
      print(e.toString());
    }
    return jsonResult;
  }
}
