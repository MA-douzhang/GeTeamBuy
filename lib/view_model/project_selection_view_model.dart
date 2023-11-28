import '../../../constant/app_parameters.dart';
import '../../../model/goods_entity.dart';
import '../../../model/project_selection_detail_entity.dart';
import '../../../service/project_selection_service.dart';
import '../../../utils/toast_util.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/page_state.dart';

class ProjectSelectionViewModel extends BaseViewModel {
  ProjectSelectionService _projectSelectionService = ProjectSelectionService();
  ProjectSelectionDetailTopic? _projectSelectionDetailTopic;
  List<GoodsEntity> _goods = [];
  List<ProjectSelectionDetailTopic> _relatedProjectSelectionDetailTopics =
      [];

  ProjectSelectionDetailTopic? get projectSelectionDetailTopic =>
      _projectSelectionDetailTopic;

  List<ProjectSelectionDetailTopic> get relatedProjectSelectionDetailTopics =>
      _relatedProjectSelectionDetailTopics;

  List<GoodsEntity> get goods => _goods;

  queryDetail(int id) {
    var parameters = {AppParameters.ID: id};
    _projectSelectionService
        .projectSelectionDetail(parameters)
        .then((response) {
      if (response.isSuccess ?? false) {
        _projectSelectionDetailTopic = response.data?.topic;
        _goods = response.data?.goods ?? [];
        pageState = PageState.hasData;
        queryRelatedGoods(parameters);
      } else {
        ToastUtil.showToast(response.message ?? '');
      }
    });
  }

  queryRelatedGoods(var parameters) {
    _projectSelectionService
        .projectSelectionRecommend(parameters)
        .then((response) {
      if (response.isSuccess ?? false) {
        _relatedProjectSelectionDetailTopics = response.data?.xList ?? [];
        notifyListeners();
      } else {
        ToastUtil.showToast(response.message ?? '');
      }
    });
  }
}
