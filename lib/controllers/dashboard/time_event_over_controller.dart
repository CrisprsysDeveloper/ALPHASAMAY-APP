import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class TimeEventOverController extends GetxController {
  final TokenRepository authRepository;

  TimeEventOverController({required this.authRepository});

  final List<Map<String, dynamic>> records = [
    {
      'name': 'Harish Narakuduru',
      'userId': '1007',
      'datetime': '05/02/2025 20:00:00',
      'checkType': 'Check Out',
    },
    {
      'name': 'Harish Narakuduru',
      'userId': '1007',
      'datetime': '05/02/2025 11:16:00',
      'checkType': 'Check In',
    },
    {
      'name': 'Harish Narakuduru',
      'userId': '1007',
      'datetime': '04/02/2025 19:18:00',
      'checkType': 'Check Out',
    },
    {
      'name': 'Harish Narakuduru',
      'userId': '1007',
      'datetime': '04/02/2025 11:19:00',
      'checkType': 'Check In',
    },
  ];

  String selectedYear = '2025';
  String selectedMonth = 'February';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--TimeEventOverController----->');
  }

}
