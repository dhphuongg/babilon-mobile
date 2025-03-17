import 'package:babilon/core/domain/storages/global_storages.dart';
import 'package:babilon/presentation/pages/root/root_screen.dart';

class InitRoute {
  Future<void> getInitialRoute() async {
    GlobalStorage.initialRoute = const RootScreen();
  }
}
