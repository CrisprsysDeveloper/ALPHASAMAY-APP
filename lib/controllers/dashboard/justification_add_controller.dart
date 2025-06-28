import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class JustificationAddController extends GetxController {
  final TokenRepository authRepository;

  JustificationAddController({required this.authRepository});


  @override
  void onInit() {
    super.onInit();
    printf('<------init--CreateTimeEventsController----->');
  }

}
