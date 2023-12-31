import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_colors.dart';
import '../../../model/category_entity.dart';
import '../../../view_model/category_goods_view_model.dart';
import 'category_goods_widget.dart';

class HomeCategoryGoodsPage extends StatefulWidget {
  final String title;
  final int id;

  HomeCategoryGoodsPage(this.title, this.id);

  @override
  _HomeCategoryGoodsPageState createState() => _HomeCategoryGoodsPageState();
}

class _HomeCategoryGoodsPageState extends State<HomeCategoryGoodsPage>
    with TickerProviderStateMixin {
  CategoryGoodsViewModel _categoryGoodsViewModel = CategoryGoodsViewModel();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _categoryGoodsViewModel.queryCategoryName(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _categoryGoodsViewModel,
        child:
            Consumer<CategoryGoodsViewModel>(builder: (context, model, child) {
          _tabController = TabController(
              length: model.categoryTitleEntity == null
                  ? 0
                  : model.categoryTitleEntity?.brotherCategory?.length ?? 0,
              vsync: this);
          return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: Material(
                    color: AppColors.COLOR_FFFFFF,
                    child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorColor: AppColors.COLOR_FF5722,
                        labelColor: AppColors.COLOR_FF5722,
                        unselectedLabelColor: AppColors.COLOR_999999,
                        tabs: tabBars(model?.categoryTitleEntity == null
                            ? []
                            : model?.categoryTitleEntity?.brotherCategory ?? []) ?? []),
                  ),
                )),
            body: TabBarView(
                controller: _tabController,
                children: tabBarViews(model?.categoryTitleEntity == null
                    ? []
                    : model?.categoryTitleEntity?.brotherCategory ?? [])),
          );
        }));
  }

  List<Widget> tabBars(List<CategoryEntity> titles) {
    List<Widget> titlesWidget = [];
    for (var item in titles) {
      titlesWidget.add(Tab(text: item.name));
    }
    return titlesWidget;
  }

  List<Widget> tabBarViews(List<CategoryEntity> titles) {
    List<Widget> contentWidgets = [];
    for (var item in titles) {
      contentWidgets.add(CategoryGoodsWidget(item?.id ?? 0));
    }
    return contentWidgets;
  }
}
