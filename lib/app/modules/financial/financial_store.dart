import 'package:mobx/mobx.dart';

part 'financial_store.g.dart';

class FinancialStore = _FinancialStoreBase with _$FinancialStore;

abstract class _FinancialStoreBase with Store {
  @observable
  bool selectMonth = false;
  @observable
  int monthSelected = DateTime.now().month;

  @action
  void setSelectMonth(_selectMonth) => selectMonth = _selectMonth;
  @action
  void setMonthSelected(_monthSelected) => monthSelected = _monthSelected;
}
