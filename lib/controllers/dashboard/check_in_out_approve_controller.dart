import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class CheckInOutApproveController extends GetxController {
  final TokenRepository authRepository;

  CheckInOutApproveController({required this.authRepository});

  final List<Map<String, String>> users =   [
    {
      'id': '1009',
      'name': 'Ashok Kumar Gudi',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'id': '1007',
      'name': 'Harish Narakuduru',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'id': '1006',
      'name': 'Narendar chaluvadi',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'id': '1012',
      'name': 'Venkat',
      'image': 'https://via.placeholder.com/150'
    },
  ];


  @override
  void onInit() {
    super.onInit();
    printf('<------init--CreateTimeEventsController----->');
  }

}
