import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moneymate/data/app_db.dart';

final getIt = GetIt.instance;

Future<void> setupInjector() async {
  getIt.registerSingleton(AppDatabase());
  final sp = await SharedPreferences.getInstance();
  getIt.registerSingleton(sp);
}