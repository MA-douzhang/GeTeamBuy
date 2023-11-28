import '../../../model/address_entity.dart';
import '../../../service/mine_service.dart';
import '../../../view_model/base_view_model.dart';
import '../../../view_model/page_state.dart';

class AddressViewModel extends BaseViewModel {
  MineService _mineService = MineService();
  List<AddressList> _address = [];

  List<AddressList> get address => _address;

  queryAddressData() {
    _mineService.getAddressList().then((response) {
      if (response.isSuccess ?? false) {
        address.clear();
        _address = response.data?.xList ?? [];
        pageState = address.length == 0 ? PageState.empty : PageState.hasData;
        notifyListeners();
      } else {
        errorNotify(response.message ?? '');
      }
    });
  }
}