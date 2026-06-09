import 'package:e_com_user/general/core/injection/injection_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> confirugationDependency() async {
  await getIt.init();
}
