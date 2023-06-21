import 'package:griot_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainAccountIdProvider {
  Future<int> getMainAccountId();
}

class MainAccountIdProviderImpl implements MainAccountIdProvider {
  @override
  Future<int> getMainAccountId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? mainAccountId = prefs.getString('main_account_id') as int?;

    if (mainAccountId == null) {
      throw NoMainAccountException();
    } else {
      return mainAccountId;
    }
  }
}
