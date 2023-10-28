import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

class SignUpStore = _SignUpStoreBase with _$SignUpStore;

abstract class _SignUpStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
