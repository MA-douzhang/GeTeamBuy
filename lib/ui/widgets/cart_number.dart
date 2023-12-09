import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_dimens.dart';
import '../../../constant/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CartNumberView extends StatefulWidget {
  final _number;
  final ValueChanged<int> onNumberChange;
  const CartNumberView(this._number, this.onNumberChange, {super.key});

  @override
  _CartNumberViewState createState() => _CartNumberViewState();
}

class _CartNumberViewState extends State<CartNumberView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(AppDimens.DIMENS_240),
      height: ScreenUtil().setWidth(AppDimens.DIMENS_80),
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () => _reduce(),
              child: Container(
                width: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                height: double.infinity,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                    shape: Border(
                        left: BorderSide(
                            color: AppColors.COLOR_F0F0F0, width: 1.0),
                        top: BorderSide(
                            color: AppColors.COLOR_F0F0F0, width: 1.0),
                        right: BorderSide(
                            color: AppColors.COLOR_F0F0F0, width: 1.0),
                        bottom: BorderSide(
                            color: AppColors.COLOR_F0F0F0, width: 1.0))),
                child: Text(
                  "-",
                  style: FMTextStyle.color_333333_size_42
                ),
              )),
          Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: ScreenUtil().setWidth(AppDimens.DIMENS_80),
            decoration: ShapeDecoration(
                shape: Border(
                    top: BorderSide(color: AppColors.COLOR_F0F0F0, width: 1.0),
                    bottom:
                        BorderSide(color: AppColors.COLOR_F0F0F0, width: 1.0))),
            child: Text(
              '${widget._number}',
              style: FMTextStyle.color_333333_size_42
            ),
          ),
          InkWell(
              onTap: () => _add(),
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                height: double.infinity,
                decoration: ShapeDecoration(
                  color: AppColors.COLOR_FF5722,
                    shape: Border(
                        left: BorderSide(
                            color: AppColors.COLOR_FF5722, width: 1.0),
                        top: BorderSide(
                            color: AppColors.COLOR_FF5722, width: 1.0),
                        right: BorderSide(
                            color: AppColors.COLOR_FF5722, width: 1.0),
                        bottom: BorderSide(
                            color: AppColors.COLOR_FF5722, width: 1.0))),
                child: Text(
                  "+",
                  style: FMTextStyle.color_ffffff_size_42
                ),
              )),
        ],
      ),
    );
  }

  _reduce() {
    if (widget._number > 1) {
      widget.onNumberChange(widget._number - 1);
    }
  }

  _add() {
    debugPrint("加号键");
    widget.onNumberChange(widget._number + 1);
  }
}
