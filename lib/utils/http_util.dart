import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ge_team_buy/utils/shared_preferences_util.dart';

import '../constant/app_strings.dart';
import '../router/application.dart';
import '../router/routers.dart';

class HttpUtil {
  // 工厂模式
  static HttpUtil get instance => _getInstance();
  static HttpUtil _httpUtil = HttpUtil();
  var dio;

  static HttpUtil _getInstance() {
    if (_httpUtil == null) {
      _httpUtil = new HttpUtil();
    }

    return _httpUtil;
  }

  HttpUtil() {
    dio = Dio();

    // 请求拦截
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          //如果token存在在请求头加上token
          await SharedPreferencesUtil.getInstance()
              ?.getString(AppStrings.TOKEN)
              .then((token) {
            if(token !=null){
              options.headers.addAll({AppStrings.TOKEN: token});
            }
            options.connectTimeout= Duration(seconds: 5);
            options.receiveTimeout= Duration(seconds: 5);
            debugPrint("token================$token" );
          });
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
          return handler.next(e);
        },
      ),
    );
  }

  //get请求
  Future get(String url,
      {required Map<String, dynamic> parameters, Options? options}) async {
    Response response;
    if (options != null) {
      response =
          await dio.get(url, queryParameters: parameters, options: options);
    } else if (options == null) {
      response = await dio.get(url, queryParameters: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.get(url, options: options);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  //post请求
  Future post(String url,
      {required Map<String, dynamic> parameters, Options? options}) async {
    Response response;
    if (options != null) {
      response = await dio.post(url, data: parameters, options: options);
    } else if (options == null) {
      response = await dio.post(url, data: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.post(url, options: options);
    } else {
      response = await dio.post(url);
    }
    return response.data;
  }
}
