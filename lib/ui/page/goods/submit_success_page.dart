import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_dimens.dart';
import '../../../constant/app_images.dart';
import '../../../constant/app_strings.dart';
import '../../../constant/text_style.dart';
import '../../../router/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_colors.dart';

class SubmitSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.SUBMIT_SUCCESS),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.COLOR_FFFFFF,
        alignment: Alignment.center,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_200))),
            Image.asset(
              AppImages.SUCCESS,
              width: ScreenUtil().setWidth(AppDimens.DIMENS_300),
              height: ScreenUtil().setWidth(AppDimens.DIMENS_300),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_60))),
            Text(
              AppStrings.SUBMIT_SUCCESS,
              style: FMTextStyle.color_333333_size_42,
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_200))),
            Row(
              children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                            right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                        child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                          child: Text(
                            AppStrings.BACK_HOME,
                            style: FMTextStyle.color_333333_size_42,
                          ),
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context, Routers.root, (route) => false),
                        ))),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                            right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                        child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.COLOR_FF5722)),
                          child: Text(
                            AppStrings.CHECK_BILL,
                            style: FMTextStyle.color_333333_size_42,
                          ),
                          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(Routers.orderPage, ModalRoute.withName(Routers.root)),
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
