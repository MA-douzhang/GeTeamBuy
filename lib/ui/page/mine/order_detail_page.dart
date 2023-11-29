import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_dimens.dart';
import '../../../constant/app_images.dart';
import '../../../constant/app_strings.dart';
import '../../../constant/text_style.dart';
import '../../../event/order_refresh_event.dart';
import '../../../model/order_detail_entity.dart';
import '../../../ui/widgets/divider_line.dart';
import '../../../ui/widgets/item_text.dart';
import '../../../ui/widgets/view_model_state_widget.dart';
import '../../../view_model/order_detail_view_model.dart';
import '../../../view_model/order_view_model.dart';
import '../../../view_model/page_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  OrderDetailPage(this.orderId);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailViewModel _orderDetailViewModel = OrderDetailViewModel();
  OrderViewModel _orderViewModel = OrderViewModel();

  @override
  void initState() {
    super.initState();
    _orderDetailViewModel.queryOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.MINE_ORDER_DETAIL),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => _orderDetailViewModel,
        child: Consumer<OrderDetailViewModel>(builder: (context, model, child) {
          return _initView(model) ?? Text('data');
        }),
      ),
    );
  }

  Widget? _initView(OrderDetailViewModel orderDetailViewModel) {
    if (orderDetailViewModel.pageState == PageState.hasData) {
      return _contentView(orderDetailViewModel);
    }
    return ViewModelStateWidget.stateWidget(orderDetailViewModel);
  }

  Widget _contentView(OrderDetailViewModel orderDetailViewModel) {
    OrderDetailEntity orderDetailEntity =
        orderDetailViewModel.orderDetailEntity ?? OrderDetailEntity();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _addressWidget(orderDetailEntity),
              DividerLineView(),
              _orderGoodsWidget(orderDetailEntity),
              DividerLineView(),
              _goodsPriceMessage(orderDetailEntity),
              _billNoMessage(orderDetailEntity)
            ]),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: orderDetailEntity.orderInfo?.handleOption?.delete ?? false,
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                    child: Text(
                      AppStrings.DELETE,
                      style: FMTextStyle.color_333333_size_42,
                    ),
                    onPressed: () =>
                        _showDialog(2, orderDetailEntity?.orderInfo?.id ?? 0),
                  )),
            ),
            //订单未付款阶段
            Visibility(
              visible: orderDetailEntity?.orderInfo?.handleOption?.cancel ??  false,
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                        child: Text(
                          AppStrings.PAY,
                          style: FMTextStyle.color_333333_size_42,
                        ),
                        onPressed: () =>
                            _payDialog(orderDetailEntity?.orderInfo?.id ?? 0),
                      ),
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                        child: Text(
                          AppStrings.CANCEL,
                          style: FMTextStyle.color_333333_size_42,
                        ),
                        onPressed: () =>
                            _showDialog(1, orderDetailEntity?.orderInfo?.id ?? 0),
                      ),

                    ],
                  )),
            ),
            Visibility(
              visible: orderDetailEntity?.orderInfo?.orderStatusText==AppStrings.ORDER_SEND,
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                        child: Text(
                          AppStrings.MINE_ORDER_CONFIRM_TIPS,
                          style: FMTextStyle.color_333333_size_42,
                        ),
                        onPressed: () =>
                            _confirmDialog(orderDetailEntity?.orderInfo?.id ?? 0),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _addressWidget(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(AppDimens.DIMENS_180),
            alignment: Alignment.center,
            child: Image.asset(
              AppImages.ORDER_LOCATION,
              width: ScreenUtil().setWidth(AppDimens.DIMENS_100),
              height: ScreenUtil().setWidth(AppDimens.DIMENS_100),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    orderDetailEntity?.orderInfo?.consignee ?? '',
                    style: FMTextStyle.color_333333_size_42,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  ),
                  Text(
                    orderDetailEntity.orderInfo?.mobile ?? '',
                    style: FMTextStyle.color_333333_size_42,
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_30))),
              Text(
                orderDetailEntity.orderInfo?.address ?? '',
                style: FMTextStyle.color_333333_size_42,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _orderGoodsWidget(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil().setHeight(AppDimens.DIMENS_80),
                child: Text(
                  AppStrings.APP_NAME,
                  style: FMTextStyle.color_333333_size_42,
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  orderDetailEntity.orderInfo?.orderStatusText ?? '',
                  style: FMTextStyle.color_ff5722_size_42,
                ),
              )),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: orderDetailEntity.orderGoods?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return _goodItemView(
                    orderDetailEntity.orderGoods?[index] ??  OrderGood(),
                    orderDetailEntity.orderGoods?.length == 1 ||
                        index == orderDetailEntity.orderGoods?.length);
              })
        ],
      ),
    );
  }

  Widget _goodItemView(OrderGood good, bool showLine) {
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
                    Text(good.goodsName ?? '',
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
                          style: FMTextStyle.color_ff5722_size_42,
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

  Widget _goodsPriceMessage(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      child: Column(
        children: [
          ItemTextView(AppStrings.MINE_ORDER_DETAIL_TOTAL,
              AppStrings.DOLLAR + "${orderDetailEntity.orderInfo?.goodsPrice ?? ''}"),
          DividerLineView(),
          ItemTextView(
              AppStrings.FREIGHT,
              AppStrings.DOLLAR +
                  "${orderDetailEntity.orderInfo?.freightPrice}"),
          DividerLineView(),
          ItemTextView(AppStrings.MINE_ORDER_DETAIL_PREFERENCES,
              AppStrings.DOLLAR + "${orderDetailEntity.orderInfo?.couponPrice}"),
          DividerLineView(),
          ItemTextView(AppStrings.MINE_ORDER_DETAIL_PAYMENTS,
              AppStrings.DOLLAR + "${orderDetailEntity.orderInfo?.actualPrice}"),
        ],
      ),
    );
  }

  Widget _billNoMessage(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
      child: Column(
        children: [
          ItemTextView(
              AppStrings.MINE_ORDER_SN, orderDetailEntity.orderInfo?.orderSn),
          DividerLineView(),
          ItemTextView(
              AppStrings.MINE_ORDER_TIME, orderDetailEntity.orderInfo?.addTime),
        ],
      ),
    );
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
  ///支付弹窗
  _payDialog(int orderId) {
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
            AppStrings.MINE_ORDER_PAY_TIPS,
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
                      _payOrder(orderId);
                  },
                  child: Text(
                    AppStrings.CONFIRM,
                    style: FMTextStyle.color_333333_size_42,
                  )),
            ],
          );
        });
  }
  ///确认收货
  _confirmDialog(int orderId) {
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
              AppStrings.MINE_ORDER_CONFIRM_TIPS,
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
                    _confirmOrder(orderId);
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
  ///支付订单
  _payOrder(int orderId) {
    _orderViewModel.payOrder(orderId).then((value) {
      if (value) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }
  ///确认收货
  _confirmOrder(int orderId) {
    _orderViewModel.confirmOrder(orderId).then((value) {
      if (value) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }
}
