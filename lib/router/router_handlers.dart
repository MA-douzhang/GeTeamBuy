import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../constant/app_parameters.dart';
import '../ui/page/404/not_find_page.dart';
import '../ui/page/goods/category_goods_page.dart';
import '../ui/page/goods/fill_in_order_page.dart';
import '../ui/page/goods/goods_detail_page.dart';
import '../ui/page/goods/home_category_goods_page.dart';
import '../ui/page/goods/search_goods_page.dart';
import '../ui/page/goods/submit_success_page.dart';
import '../ui/page/home/brand_detail_page.dart';
import '../ui/page/home/home_page.dart';
import '../ui/page/home/main_page.dart';
import '../ui/page/home/project_selection_detail_page.dart';
import '../ui/page/login/login_page.dart';
import '../ui/page/login/register_page.dart';
import '../ui/page/mine/about_us_page.dart';
import '../ui/page/mine/address_detail_page.dart';
import '../ui/page/mine/address_page.dart';
import '../ui/page/mine/collect_page.dart';
import '../ui/page/mine/coupon_page.dart';
import '../ui/page/mine/feedback_page.dart';
import '../ui/page/mine/foot_print_page.dart';
import '../ui/page/mine/order_detail_page.dart';
import '../ui/page/mine/order_page.dart';
import '../ui/widgets/webview_widget.dart';

//引导页
var splashHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return MainPage();
});

//首页
var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return HomePage();
});

//404页面
var notFindHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return NotFindPage();
});

var categoryGoodsListHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<Object>> parameters) {
  var categoryName = jsonDecode(parameters[AppParameters.CATEGORY_NAME]?.first as String);
  var categoryId = int.parse(parameters[AppParameters.CATEGORY_ID]?.first  as String);
  return CategoryGoodsPage(categoryName, categoryId);
});

var goodsDetailsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<Object>> parameters) {
  var goodsId = int.parse(parameters[AppParameters.GOODS_ID]?.first as String);
  return GoodsDetailPage(goodsId);
});
var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return LoginPage();
});

var registerHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return RegisterPage();
});
var fillInOrderHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var cartId = int.parse(parameters[AppParameters.CART_ID]?.first  as String);
  return FillInOrderPage(cartId);
});

var addressHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var isSelect = int.parse(parameters["isSelect"]?.first  as String);
  return AddressViewPage(isSelect);
});

var editAddressHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var addressId = int.parse(parameters["addressId"]?.first  as String);
  return AddressDetailPage(addressId);
});

var couponHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return CouponPage();
});

var searchGoodsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return SearchGoodsPage();
});

var webViewHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var title = jsonDecode(parameters["titleName"]?.first  as String);
  var url = jsonDecode(parameters["url"]?.first  as String);
  return WebViewPage(url, title);
});

var brandDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var title = jsonDecode(parameters["titleName"]?.first  as String);
  var id = int.parse(parameters["id"]?.first  as String);
  return BrandDetailPage(title, id);
});

var projectSelectionDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var id = int.parse(parameters["id"]?.first  as String);
  return ProjectSelectionDetailView(id);
});

var collectHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return CollectPage();
});

var aboutUsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return AboutUsPage();
});

var feedBackHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return FeedBackPage();
});

var footPrintHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return FootPrintPage();
});

var submitSuccessHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return SubmitSuccessPage();
});

var homeCategoryGoodsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var title = jsonDecode(parameters["title"]?.first  as String);
  var id = int.parse(parameters["id"]?.first  as String);
  return HomeCategoryGoodsPage(title, id);
});

var orderHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var initIndex =
      int.parse(parameters.length == 0 ? "0" : parameters["initIndex"]?.first  as String);
  return OrderPage(initIndex);
});

var orderDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var orderId = int.parse(parameters["orderId"]?.first  as String);
  return OrderDetailPage(orderId);
});
