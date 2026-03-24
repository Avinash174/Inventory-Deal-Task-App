import 'package:shared_preferences/shared_preferences.dart';

abstract class DealLocalDataSource {
  Future<void> toggleInterest(String dealId);
  Future<List<String>> getInterestedDealIds();
}

class DealLocalDataSourceImpl implements DealLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String key = 'INTERESTED_DEALS';

  DealLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getInterestedDealIds() async {
    final List<String>? ids = sharedPreferences.getStringList(key);
    return ids ?? [];
  }

  @override
  Future<void> toggleInterest(String dealId) async {
    final List<String> ids = await getInterestedDealIds();
    if (ids.contains(dealId)) {
      ids.remove(dealId);
    } else {
      ids.add(dealId);
    }
    await sharedPreferences.setStringList(key, ids);
  }
}
