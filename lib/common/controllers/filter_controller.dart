import 'package:get/get.dart';

class FilterController extends GetxController implements GetxService{
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  String? _selectedSortingType;
  String? get selectedSortingType => _selectedSortingType;

  Future<void> setSelectedDate({required DateTime? startDate, required DateTime? endDate}) async {
    _startDate = startDate;
    _endDate = endDate;
    update();
  }

  void updateSelectedFavType(String type, {bool isUpdate = true}){
    _selectedSortingType = type;
    if(isUpdate){
      update();
    }
  }

  void clearFilter(){
    _startDate = null;
    _endDate = null;
    _selectedSortingType = 'latest';
    update();
  }
}