import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class CheckInOutController extends GetxController {
  final TokenRepository authRepository;

  CheckInOutController({required this.authRepository});

  String selectedYear = 'Partner Type';
  String selectedMonth = 'Employee Type';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--CheckInOutController----->');
  }

}
