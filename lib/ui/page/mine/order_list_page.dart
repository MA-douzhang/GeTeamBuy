import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_dimens.dart';
import '../../../constant/app_strings.dart';
import '../../../constant/text_style.dart';
import '../../../event/order_refresh_event.dart';
import '../../../model/order_list_entity.dart';
import '../../../ui/widgets/divider_line.dart';
import '../../../ui/widgets/view_model_state_widget.dart';
import '../../../utils/navigator_util.dart';
import '../../../utils/refresh_state_util.dart';
import '../../../view_model/order_view_model.dart';
import '../../../view_model/page_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderListPage extends StatefulWidget {
  int showType = 0;

  OrderListPage({required this.showType});

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with AutomaticKeepAliveClientMixin {
  OrderViewModel _orderViewModel = OrderViewModel();
  RefreshController _refreshController = RefreshController();
  int _pageIndex = 1;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _orderViewModel.queryOrder(widget.showType, _pageIndex, _pageSize);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    orderEventBus.on<OrderRefreshEvent>().listen((event) {
      _pageIndex = 1;
      _pageSize = 20;
      _orderViewModel.queryOrder(widget.showType, _pageIndex, _pageSize);
    });
    return Material(
        child: ChangeNotifierProvider(
            create: (_) => _orderViewModel,
            child: Consumer<OrderViewModel>(builder: (context, model, child) {
              print(_pageIndex);
              _pageIndex = model.canLoadMore ? ++_pageIndex : _pageIndex;
              print(_pageIndex);
              print(_orderViewModel.canLoadMore);
              print(model.canLoadMore);
              RefreshStateUtil.getInstance()
                  .stopRefreshOrLoadMore(_refreshController);
              return _initView(model);
            })));
  }

  Widget _initView(OrderViewModel orderViewModel) {
    if (orderViewModel.pageState == PageState.hasData) {
      return _contentView(orderViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        orderViewModel, _onRefresh);
  }

  Widget _contentView(OrderViewModel orderViewModel) {
    return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
        child: SmartRefresher(
          onRefresh: () => _onRefresh(),
          onLoading: () => _onLoadMore(),
          enablePullDown: true,
          enablePullUp: orderViewModel.canLoadMore,
          header: ClassicHeader(),
          controller: _refreshController,
          child: ListView.builder(
              itemCount: orderViewModel.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _orderItemView(orderViewModel.data[index]);
                // return Text("data");
              }),
        ));
  }

  _onRefresh() {
    _pageIndex = 1;
    _orderViewModel.queryOrder(widget.showType, _pageIndex, _pageSize);
  }

  _onLoadMore() {
    _orderViewModel.queryOrder(widget.showType, _pageIndex, _pageSize);
  }

  Widget _orderItemView(OrderEntity order) {
    return Card(
        child: InkWell(
            onTap: () => NavigatorUtil.goOrderDetailPage(context, order?.id??0),
            child: Container(
              margin:
                  EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppStrings.APP_NAME,
                          style: TextStyle(
                              color: AppColors.COLOR_333333,
                              fontSize:
                                  ScreenUtil().setSp(AppDimens.DIMENS_42)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil()
                                    .setWidth(AppDimens.DIMENS_20))),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${order.orderStatusText}"),
                                  ],
                                )))
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: order.goodsList?.length ?? 0,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _goodItemView(
                            order.goodsList?[index] ??OrderGoodsEntity() ,
                            order.goodsList?.length == 1 ||
                                index == order.goodsList?.length);
                      }),
                  Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                          top: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                              AppStrings.MINE_ORDER_TOTAL_GOODS +
                                  "${goodNumber(order?.goodsList ?? [])}" +
                                  AppStrings.MINE_ORDER_GOODS_TOTAL,
                              style: FMTextStyle.color_999999_size_36),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil()
                                      .setWidth(AppDimens.DIMENS_30))),
                          Text(
                              AppStrings.MINE_ORDER_PRICE +
                                  "${order.actualPrice}",
                              style: FMTextStyle.color_ff5722_size_42),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                    visible: order.handleOption?.delete ?? false,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(AppDimens.DIMENS_30),
                                            right: ScreenUtil()
                                                .setWidth(AppDimens.DIMENS_20)),
                                        height: ScreenUtil()
                                            .setHeight(AppDimens.DIMENS_80),
                                        width: ScreenUtil()
                                            .setWidth(AppDimens.DIMENS_200),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                  AppColors.COLOR_FF5722)),
                                          child: Text(
                                            AppStrings.DELETE,
                                            style: FMTextStyle
                                                .color_333333_size_42,
                                          ),
                                          onPressed: () =>
                                              _showDialog(2, order?.id ?? 0),
                                        ))),
                                Visibility(
                                    visible: order?.handleOption?.cancel ?? false,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(AppDimens.DIMENS_30),
                                            right: ScreenUtil()
                                                .setWidth(AppDimens.DIMENS_20)),
                                        height: ScreenUtil()
                                            .setHeight(AppDimens.DIMENS_80),
                                        width: ScreenUtil()
                                            .setWidth(AppDimens.DIMENS_200),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                  AppColors.COLOR_FF5722)),
                                          child: Text(
                                            AppStrings.CANCEL,
                                            style: FMTextStyle
                                                .color_333333_size_42,
                                          ),
                                          onPressed: () =>
                                              _showDialog(1, order?.id ?? 0),
                                        )))
                              ],
                            ),
                          ))
                        ],
                      ))
                ],
              ),
            )));
  }

  Widget _goodItemView(OrderGoodsEntity good, bool showLine) {
    return Container(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              good.picUrl ?? '',
              width: ScreenUtil().setWidth(AppDimens.DIMENS_300),
              height: ScreenUtil().setHeight(AppDimens.DIMENS_300),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(good?.goodsName ?? '',
                        style: FMTextStyle.color_333333_size_42),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                    Text(
                      good.specifications?[0] ?? '',
                      style: FMTextStyle.color_999999_size_42,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                    Row(
                      children: [
                        Text(
                          AppStrings.DOLLAR + "${good.price}",
                          style: FMTextStyle.color_ff5722_size_26,
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "x${good.number}",
                            style: FMTextStyle.color_999999_size_36,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: showLine,
          child: Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
            child: DividerLineView(),
          ),
        )
      ],
    ));
  }

  _showDialog(int action, int orderId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppStrings.TIPS,
              style: FMTextStyle.color_333333_size_48,
            ),
            content: Text(
              action == 1
                  ? AppStrings.MINE_ORDER_CANCEL_TIPS
                  : AppStrings.MINE_ORDER_DELETE_TIPS,
              style: FMTextStyle.color_333333_size_42,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.CANCEL,
                    style: FMTextStyle.color_ff5722_size_42,
                  )),
              TextButton(

                  onPressed: () {
                    Navigator.pop(context);
                    if (action == 1) {
                      _cancelOrder(orderId);
                    } else {
                      _deleteOrder(orderId);
                    }
                  },
                  child: Text(
                    AppStrings.CONFIRM,
                    style: FMTextStyle.color_333333_size_42,
                  )),
            ],
          );
        });
  }

  _deleteOrder(int orderId) {
    _orderViewModel.deleteOrder(orderId).then((value) {
      if (value) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }

  _cancelOrder(int orderId) {
    _orderViewModel.cancelOrder(orderId).then((value) {
      if (value) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }

  int goodNumber(List<OrderGoodsEntity> order) {
    int number = 0;
    order.forEach((good) {
      number += good.number ?? 0;
    });
    return number;
  }
}
