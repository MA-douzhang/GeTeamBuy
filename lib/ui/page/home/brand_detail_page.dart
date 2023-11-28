import 'package:flutter/material.dart';
import '../../../constant/app_dimens.dart';
import '../../../constant/text_style.dart';
import '../../../ui/widgets/cached_image.dart';
import '../../../ui/widgets/view_model_state_widget.dart';
import '../../../view_model/brand_detail_view_model.dart';
import '../../../view_model/page_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BrandDetailPage extends StatefulWidget {
  final titleName;
  final id;

  BrandDetailPage(this.titleName, this.id);

  @override
  _BrandDetailPageState createState() => _BrandDetailPageState();
}

class _BrandDetailPageState extends State<BrandDetailPage> {
  BrandDetailViewModel _brandDetailViewModel = BrandDetailViewModel();

  @override
  void initState() {
    super.initState();
    _brandDetailViewModel.queryBrandDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.titleName),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
          create: (_) => _brandDetailViewModel,
          child: Consumer<BrandDetailViewModel>(builder:
              (BuildContext context, BrandDetailViewModel model, Widget? child) {
            return _initWidget(model);
          }),
        ));
  }

  Widget _initWidget( BrandDetailViewModel brandDetailViewModel) {
    if (brandDetailViewModel.pageState == PageState.hasData) {
      return _contentView(brandDetailViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(brandDetailViewModel,(){});
  }

  Widget _contentView(BrandDetailViewModel brandDetailViewModel) {
    return SingleChildScrollView(
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: CachedImageView(
                        double.infinity,
                        ScreenUtil().setHeight(AppDimens.DIMENS_400),
                        brandDetailViewModel.brandDetialEntity?.picUrl ?? ''),
                  ),
                  Container(
                    margin: EdgeInsets.all(
                        ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                    child: Text(
                      brandDetailViewModel.brandDetialEntity?.desc ?? '',
                      style: FMTextStyle.color_333333_size_42
                    ),
                  )
                ])));
  }
}
