import 'package:mobx/mobx.dart';

part 'sign_email_store.g.dart';

class SignEmailStore = _SignEmailStoreBase with _$SignEmailStore;

abstract class _SignEmailStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
