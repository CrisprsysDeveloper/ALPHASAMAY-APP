import 'dart:convert';
import 'dart:io';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio_;
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:intl/intl.dart';

class FaceRegistrationController extends GetxController {
  final TokenRepository authRepository;

  FaceRegistrationController({required this.authRepository});

  String selectedYear = 'Business Object';
  String selectedMonth = 'Object Number';

  // File? image;
  var image = Rxn<File>();
  final RxString pickedImagePath = ''.obs;
  final RxString pickedImageName = ''.obs;

  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';

  RxList<Map<String, String>> businessObjectDropdownItems =
      <Map<String, String>>[].obs; // BusinessObjectsList
  //
  RxString selectedObject = ''.obs; // Object Number
  RxString selectedObjectNumber = ''.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm:ss');

  // Reactive formatted strings
  RxString defaultDate = ''.obs;
  RxString defaultTime = ''.obs;

  RxList<AttendanceUser> fullAttendanceUserList = <AttendanceUser>[].obs;
  RxList<AttendanceUser> filteredAttendanceUserList = <AttendanceUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--FaceRegistrationController----->');
    defaultDate.value = dateFormat.format(selectedDate.value);

    final now = DateTime.now();
    final fullDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );
    defaultTime.value = timeFormat.format(fullDateTime);

    loadSavedCredentials();
    getDropDownListApi(clientId: clientId, userName: userName);
  }

  void loadSavedCredentials() {
    final savedUsername = box.read(AppConstants.prefUsername);
    final companyId = box.read(AppConstants.prefClientID);

    if (savedUsername != null) {
      userName = savedUsername;
    }

    if (companyId != null) {
      clientId = companyId;
    }

    printf('<---userName-->$userName---clientId--->$clientId');
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      defaultDate.value = dateFormat.format(picked);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;

      // Convert TimeOfDay to DateTime to format as HH:mm:ss
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      defaultTime.value = timeFormat.format(dt);
    }
  }

  Future<void> getDropDownListApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--clientId-$clientId--userName-->$userName');

    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getGetFaceRekognitionScreenDataApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'BusObjCode': 'CRIS_BUS_GS_FaceRegistration_NT',
            'SMode': 'Create',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        printf('<----response---->${response.data}');

        /// Parse response using your model
        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        final AttendanceUserResponse attendanceUserResponse =
            AttendanceUserResponse.fromJson(outerJson);

        final serviceStatus = attendanceUserResponse.serviceStatus;
        final List<AttendanceUser> attendanceUsers =
            attendanceUserResponse.attendanceUserList;
        fullAttendanceUserList.value = attendanceUsers;
        final List<BusinessObject> businessObjects =
            attendanceUserResponse.businessObjectsList;

        printf('MessageCode: ${serviceStatus.messageCode}');
        printf('MessageDescription: ${serviceStatus.messageDescription}');

        if (serviceStatus.messageCode == "200") {
          // Now use attendanceUsers and businessObjects as needed
          for (var user in attendanceUsers) {
            printf('AttendanceUser: ${user.id}, ${user.description}');
          }

          for (var obj in businessObjects) {
            printf('BusinessObject: ${obj.id}, ${obj.value}');
          }

          businessObjectDropdownItems.value =
              businessObjects
                  .map((obj) => {'id': obj.id, 'label': obj.value})
                  .toList();

          if (businessObjectDropdownItems.isNotEmpty) {
            selectedObject.value = businessObjectDropdownItems.first['id']!;
            filterAttendanceListBySelectedObject();
          }
        } else {
          dropDownBannerError(serviceStatus.messageDescription);
        }

        hideProgress();
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  void filterAttendanceListBySelectedObject() {
    final selectedId = selectedObject.value;

    printf('<--filter--object-list---->$selectedId');

    filteredAttendanceUserList.value =
        fullAttendanceUserList
            .where((user) => user.pType == selectedId)
            .toList();

    for (var obj in filteredAttendanceUserList) {
      printf('filteredAttendanceUserList: ${obj.id}, ${obj.description}');
    }

    if (filteredAttendanceUserList.isNotEmpty) {
      selectedObjectNumber.value = filteredAttendanceUserList.first.id;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final originalPath = pickedFile.path;
      final dir = await getTemporaryDirectory();

      final targetPath = path.join(dir.path, 'compressed_${pickedFile.name}');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalPath,
        targetPath,
        quality: 85, // Adjust this if needed
        minWidth: 1080,
      );

      if (compressedFile != null) {
        final compressed = File(compressedFile.path);
        if (compressed.lengthSync() <= 2 * 1024 * 1024) {
          image.value = compressed;
          pickedImagePath.value = compressed.path;
          pickedImageName.value = pickedFile.name;
        } else {
          Get.snackbar("Image too large", "Compressed image still exceeds 2MB");
        }
      } else {
        Get.snackbar("Error", "Image compression failed");
      }
    }
  }

  Future<void> showImageSourceDialog() async {
    await showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SafeArea(
            bottom: true,
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void registerFace() async {
    if (selectedObject.value.isEmpty || selectedObjectNumber.value.isEmpty) {
      dropDownBannerError('Please select Business Object and Object Number');
      return;
    }

    if (pickedImagePath.value.isEmpty) {
      dropDownBannerError("Please take a photo");
      return;
    }

    showProgress();

    final url =
        'https://apis.crisprsys.net/api//FaceRekognition/SaveMobileAttendanceUserProfile?CPMClientID=$clientId&CPMUserName=$userName&BusObjCode=${selectedObject.value}&ObjectNumber=${selectedObjectNumber.value}&FilePath=${pickedImagePath.value}&FaceId=';
    // final url = 'https://apis.crisprsys.net/api//FaceRekognition/AttendanceUserProfilePic?CPMClientID=1&CPMUserName=Call&BusObjCode=CRIS_BUS_GM_NewHRData_Empl&ObjectNumber=1005&FilePath=${pickedImagePath.value}&FaceId=';

    printf('<--url---->$url');
    final dio = dio_.Dio();

    final file = await MultipartFile.fromFile(
      pickedImagePath.value,
      filename: pickedImagePath.value.split('/').last,
    );

    final formData = FormData.fromMap({'AttendanceUserProfilePic': file});

    final response = await dio.post(url, data: formData);

    printf('<---response--->$response');

    final Map<String, dynamic> outerJson =
        response.data is String ? jsonDecode(response.data) : response.data;

    final Map<String, dynamic> serviceStatus = jsonDecode(
      outerJson['ServiceStatus'],
    );

    final String message =
        serviceStatus['MessageDescription'] ?? 'Unknown response';

    dropDownBannerError(message);
    hideProgress();
  }
}

class AttendanceUserResponse {
  final ServiceStatus serviceStatus;
  final List<AttendanceUser> attendanceUserList;
  final List<BusinessObject> businessObjectsList;

  AttendanceUserResponse({
    required this.serviceStatus,
    required this.attendanceUserList,
    required this.businessObjectsList,
  });

  factory AttendanceUserResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceUserResponse(
      serviceStatus: ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      attendanceUserList: List<AttendanceUser>.from(
        jsonDecode(
          json['AttendanceUserList'],
        ).map((e) => AttendanceUser.fromJson(e)),
      ),
      businessObjectsList: List<BusinessObject>.from(
        jsonDecode(
          json['BusinessObjectsList'],
        ).map((e) => BusinessObject.fromJson(e)),
      ),
    );
  }
}

class ServiceStatus {
  final String messageCode;
  final String messageDescription;

  ServiceStatus({required this.messageCode, required this.messageDescription});

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      messageCode: json['MessageCode'],
      messageDescription: json['MessageDescription'],
    );
  }
}

class AttendanceUser {
  final String id;
  final String description;
  final String pType;
  final String pTypeDesc;
  final String? prjnr;
  final String? deptId;
  final String ccode;

  AttendanceUser({
    required this.id,
    required this.description,
    required this.pType,
    required this.pTypeDesc,
    this.prjnr,
    this.deptId,
    required this.ccode,
  });

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      id: json['ID'],
      description: json['Description'],
      pType: json['PType'],
      pTypeDesc: json['PTypeDesc'],
      prjnr: json['PRJNR'],
      deptId: json['DeptID'],
      ccode: json['CCODE'],
    );
  }
}

class BusinessObject {
  final String id;
  final String value;

  BusinessObject({required this.id, required this.value});

  factory BusinessObject.fromJson(Map<String, dynamic> json) {
    return BusinessObject(id: json['ID'], value: json['Value']);
  }
}
