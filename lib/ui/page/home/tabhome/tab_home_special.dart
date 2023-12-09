import 'package:flutter/material.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_dimens.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/text_style.dart';
import '../../../../model/home_entity.dart';
import '../../../../ui/widgets/cached_image.dart';
import '../../../../utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabHomeSpecial extends StatelessWidget {
  List<HomeModelTopiclist> projectSelections;
  String title;

  TabHomeSpecial(this.title, this.projectSelections);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(AppDimens.DIMENS_56),
                  color: AppColors.COLOR_333333,
                  fontWeight: FontWeight.w600),
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: projectSelections.length,
              itemBuilder: (BuildContext context, int index) {
                return _itemView(context, projectSelections[index]);
              }),
        ],
      ),
    );
  }

  Widget _itemView(BuildContext context, HomeModelTopiclist projectSelections) {
    return Container(
      child: Card(
        child: InkWell(
          onTap: () => _goDetail(context, projectSelections.id ?? 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: CachedImageView(
                    double.infinity,
                    ScreenUtil().setHeight(AppDimens.DIMENS_400),
                    projectSelections.picUrl ?? ''),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
              Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Text(projectSelections.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FMTextStyle.color_333333_size_42)),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
              Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Text(projectSelections.subtitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FMTextStyle.color_999999_size_36)),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
              Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                      bottom: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Text(AppStrings.DOLLAR + "${projectSelections.price}",
                      style: FMTextStyle.color_ff5722_size_26)),
            ],
          ),
        ),
      ),
    );
  }

  _goDetail(BuildContext context, int id) {
    NavigatorUtil.goProjectSelectionDetailView(context, id);
  }
}
