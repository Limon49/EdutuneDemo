import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
