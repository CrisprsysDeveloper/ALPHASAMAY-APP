import 'dart:convert';
import 'package:crysprsys/model/dashboard/time_event_model.dart';
import 'package:crysprsys/model/dashboard/user_time_zone_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/checkin_checkout_type_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio_;

import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

class CheckInOutController extends GetxController {
  final TokenRepository authRepository;

  CheckInOutController({required this.authRepository});

  String selectedYear = 'Partner Type';
  String selectedMonth = 'Employee Type';

  // File? image;
  var image = Rxn<File>();
  final RxString pickedImagePath = ''.obs;
  final RxString pickedImageName = ''.obs;

  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';
  RxString userRole = ''.obs;

  var selectedEmpType = ''.obs;
  RxList<Map<String, String>> employeeTypeDropDown =
      <Map<String, String>>[].obs;

  var selectedPartnerType = ''.obs;
  RxList<Map<String, String>> partnerTypeDropdown = <Map<String, String>>[].obs;

  RxList<AuthObject> fullPartnerTypeList = <AuthObject>[].obs;
  RxList<AuthObject> filteredPartnerTypeList = <AuthObject>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm:ss');

  // Reactive formatted strings
  RxString defaultDate = ''.obs;
  RxString defaultTime = ''.obs;

  late final UserSettingsModel userSettingsTimeZone;

  RxDouble latitude = 28.7041.obs; //21.7563.obs;
  RxDouble longitude = 77.1025.obs; //72.1258.obs;

  var from = AppConstants.add;
  var checkInId = '';
  var editEmpId = '';

  RxString selectedInDate = ''.obs;
  RxString convertedCheckInDate = ''.obs;

  RxBool isView = false.obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--CheckInOutController----->');

    defaultDate.value = dateFormat.format(selectedDate.value);
    selectedInDate.value = selectedDate.value.toUtc().toIso8601String();

    // Combine selectedDate and selectedTime to build fullDateTime
    final DateTime fullDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    // Format display time (e.g., 10:30 AM)
    defaultTime.value = timeFormat.format(fullDateTime);

    // Format "yyyy-MM-dd%20HH:mm:00" for ConvertedCheckinDate
    final String convertedDate =
        "${fullDateTime.year.toString().padLeft(4, '0')}-"
        "${fullDateTime.month.toString().padLeft(2, '0')}-"
        "${fullDateTime.day.toString().padLeft(2, '0')}%20"
        "${fullDateTime.hour.toString().padLeft(2, '0')}:"
        "${fullDateTime.minute.toString().padLeft(2, '0')}:00";

    // Store for submission
    convertedCheckInDate.value = convertedDate;

    // Load saved data and dropdowns
    loadSavedCredentials();

    try {
      from = Get.arguments['from'] ?? AppConstants.add;
      if (from == AppConstants.view) {
        isView.value = true;
        AttendanceModel employee = Get.arguments['emp'];
        printf('ptype--->${employee.partnerType} -- ${employee.employeeName}');
        printf(
          '${employee.partnerType} --${employee.employeeName} --${employee.pernr} --${employee.ccode}',
        );

        selectedPartnerType.value = employee.partnerType;
        selectedEmpType.value =
            '${employee.employeeID} ${employee.employeeName}';

        defaultDate.value = employee.checkInDate.toString();
        defaultTime.value = employee.checktime.toString();
      } else if (from == AppConstants.edit) {
        checkInId = Get.arguments['checkInId'];
        printf('<---from---->$from--check-in-id-->$checkInId');
        AttendanceModel employee = Get.arguments['emp'];
        printf(
          'user-profile->${employee.regUserProfilePath} -- ${employee.regUserProfile} --checkin-->${employee.checkinUserProfilePath}',
        );
        printf('check-in-->${employee.checkinUserProfile}');
        editEmpId = employee.pernr.toString();
        getCurrentLocation();
        getUserTimeZoneApi(clientId: clientId, userName: userName).whenComplete(
          () {
            getDropDownListApi(
              clientId: clientId,
              userName: userName,
            ).whenComplete(() {
              defaultDate.value = employee.checkInDate.toString();
              defaultTime.value = employee.checktime.toString();
            });
          },
        );
      } else {
        printf('<--------fetch-location------->');
        getCurrentLocation();
        getUserTimeZoneApi(clientId: clientId, userName: userName).whenComplete(
          () {
            getDropDownListApi(clientId: clientId, userName: userName);
          },
        );
      }
    } catch (e) {
      printf('exe-from-->$e');
    }
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
    userRole.value = box.read(AppConstants.prefRoleCode);

    printf(
      '<---userName-->$userName---clientId--->$clientId---role--->${userRole.value}',
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: today, //DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedInDate.value =
          picked.toUtc().toIso8601String(); // "2025-02-06T05:00:00.000Z"
      printf('Selected UTC Date: $selectedInDate');

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
      final now = DateTime.now();

      final pickedDateTime = DateTime(
        // now.year,
        // now.month,
        // now.day,
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        picked.hour,
        picked.minute,
      );

      // final isToday =
      //     selectedDate.value.year == now.year &&
      //     selectedDate.value.month == now.month &&
      //     selectedDate.value.day == now.day;

      // if (isToday && pickedDateTime.isAfter(now))
      // {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Cannot select future time for today's date."),
      //     ),
      //   );
      //   return;
      // }

      selectedTime.value = picked;
      defaultTime.value = timeFormat.format(pickedDateTime);

      // Format as "yyyy-MM-dd%20HH:mm:00"
      final String convertedDate =
          "${pickedDateTime.year.toString().padLeft(4, '0')}-"
          "${pickedDateTime.month.toString().padLeft(2, '0')}-"
          "${pickedDateTime.day.toString().padLeft(2, '0')}%20"
          "${pickedDateTime.hour.toString().padLeft(2, '0')}:"
          "${pickedDateTime.minute.toString().padLeft(2, '0')}:00";

      // Store for submission
      convertedCheckInDate.value = convertedDate;
    }
  }

  String timeNow(String inputTime) {
    List<String> parts = inputTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String h = hour < 10 ? '0$hour' : '$hour';
    String m = minute < 10 ? '0$minute' : '$minute';
    return '$h:$m';
  }

  Future<void> getDropDownListApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--getDropDownListApi-clientId-$clientId--userName-->$userName');

    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getCheckInCheckOutDropDownListApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: {
            'BusObjCode': 'ATTEND_BUS_Attendance_Events',
            'ScreenMode': 'Display',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        printf('Full URL: ${uri.toString()}');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'BusObjCode': 'ATTEND_BUS_Attendance_Events',
            'ScreenMode': 'Display',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        printf('<----response---->$response');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        final Map<String, dynamic> serviceStatus = jsonDecode(
          outerJson['ServiceStatus'],
        );

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          final Map<String, dynamic> json = jsonDecode(response.data);
          final model = AuthResponseModel.fromJson(json);

          fullPartnerTypeList.value = model.authBasedObjectsList;

          employeeTypeDropDown.value =
              model.authBasedObjectsList.map((e) {
                return {'id': e.id ?? '', 'label': e.description ?? ''};
              }).toList();

          if (employeeTypeDropDown.isNotEmpty) {
            selectedEmpType.value = employeeTypeDropDown.first['id'] ?? '';
          }

          partnerTypeDropdown.value =
              model.partnerTypeList.map((e) {
                return {'id': e.id ?? '', 'label': e.value ?? ''};
              }).toList();

          if (partnerTypeDropdown.isNotEmpty) {
            printf('filterListBySelectedEmployee------>');
            selectedPartnerType.value = partnerTypeDropdown.first['id'] ?? '';
            filterListBySelectedEmployee();
          }
        } else {
          dropDownBannerError(messageDescription);
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

  void filterListBySelectedEmployee() {
    final selectedId = selectedPartnerType.value;

    printf('<--filter--selectedId---->$selectedId');

    filteredPartnerTypeList.value =
        fullPartnerTypeList.where((user) => user.pType == selectedId).toList();

    for (var obj in filteredPartnerTypeList) {
      printf('filteredPartnerTypeList: ${obj.id}, ${obj.description}');
    }

    if (filteredPartnerTypeList.isNotEmpty) {
      if (from == AppConstants.edit) {
        final selectedUser = filteredPartnerTypeList.firstWhere(
          (user) => user.id.toLowerCase().contains(editEmpId.toLowerCase()),
        );
        if (selectedUser != null) {
          selectedEmpType.value = selectedUser.id;
          printf('Edit mode: Matched user -> ${selectedUser.description}');
        } else {
          printf('No matching user found for editing.');
        }
      } else {
        if (userRole.value.isNotEmpty && userRole.value == 'SELF') {
          printf('USer is self role');
          selectedEmpType.value = filteredPartnerTypeList.first.id;
        } else {
          printf('USer is not self');
          selectedEmpType.value = '';
        }
      }
    }
  }

  Future<void> getUserTimeZoneApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--getUserTimeZoneApi-clientId-$clientId--userName-->$userName');

    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.getUserTimeZoneApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {'CPMClientID': clientId, 'CPMUserName': userName},
        );

        printf('<----response---->$response');

        final List<dynamic> jsonList = jsonDecode(response.toString());
        userSettingsTimeZone = UserSettingsModel.fromJson(jsonList.first);

        printf('time-zone-->${userSettingsTimeZone.userTimeZone}');

        hideProgress();
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final originalPath = pickedFile.path;
      final dir = await getTemporaryDirectory();

      // 🔹 Get extension and decide format
      final ext = path.extension(pickedFile.path).toLowerCase();
      CompressFormat format;
      String newExt;

      switch (ext) {
        case '.png':
          format = CompressFormat.png;
          newExt = '.png';
          break;
        case '.heic':
        case '.heif':
          // Convert HEIC to JPEG for compatibility
          format = CompressFormat.jpeg;
          newExt = '.jpg';
          break;
        default:
          format = CompressFormat.jpeg;
          newExt = '.jpg';
      }

      // 🔹 Build valid target path
      final targetPath = path.join(
        dir.path,
        'compressed_${path.basenameWithoutExtension(pickedFile.name)}$newExt',
      );

      // 🔹 Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalPath,
        targetPath,
        quality: 85,
        minWidth: 1080,
        format: format,
      );

      if (compressedFile != null) {
        final compressed = File(compressedFile.path);
        if (compressed.lengthSync() <= 2 * 1024 * 1024) {
          image.value = compressed;
          pickedImagePath.value = compressed.path;
          pickedImageName.value =
              'compressed_${path.basename(compressed.path)}';
        } else {
          Get.snackbar("Image too large", "Compressed image still exceeds 2MB");
        }
      } else {
        Get.snackbar("Error", "Image compression failed");
      }
    }
  }

  Future<void> pickImageOld(ImageSource source) async {
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

  Future<void> buttonCheckIn() async {
    // if (pickedImagePath.value.isEmpty)
    // {
    //   dropDownBannerError('Upload image');
    // } else
    if (selectedEmpType.value.isEmpty) {
      dropDownBannerError('select employee');
    } else if (selectedPartnerType.value.isEmpty) {
      dropDownBannerError('select employee type');
    } else {
      printf(
        'emp->${selectedEmpType.value} date->${defaultDate.value} time->${defaultTime.value}',
      );
      printf(
        'checkTime->${timeNow(defaultTime.value).toString()} lati->$latitude long->$longitude',
      );
      printf(
        'file->$pickedImagePath partnertype->${selectedPartnerType.value}',
      );

      if (from == AppConstants.add) {
        checkInApi(clientId: clientId, userName: userName, type: 'I');
      } else {
        final result = await timeEventUpdateApi(
          clientId: clientId,
          userName: userName,
          type: 'I',
          checkInId: checkInId,
        );

        if (result) {
          hideProgress();
          Get.back(result: true);
          dropDownBannerSuccess("Attendance Event Updated Successfully...!!");
        } else {
          hideProgress();
        }
      }

      //deleteEventApi(clientId: clientId, userName: userName, editId: '31447');

      printf('<---call-check-in/out--->');
    }
  }

  Future<void> checkInApi({
    required String clientId,
    required String userName,
    required String type,
  }) async {
    printf('<--checkInApi-clientId-$clientId--userName-->$userName');

    final DateTime nowUtc = DateTime.now().toUtc();
    final String createdDate = nowUtc.toIso8601String();

    Map<String, dynamic> body = {
      "EmployeeID": selectedEmpType.value,
      "CheckType": type,
      "InDate": selectedInDate.value,
      "TimeZone": userSettingsTimeZone.userTimeZone,
      "Checktime": timeNow(defaultTime.value).toString(),
      "DuplicateDate": convertedCheckInDate.value,
      "IsmanuallyDone": false,
      "DeviceSno": "",
      "CreatedDate": createdDate,
      "Latitude": latitude.value.toString(),
      "Longitude": longitude.value.toString(),
      "BusObjCode": "ATTEND_BUS_Attendance_Events",
      "PartnerType": selectedPartnerType.value,
      "filePath": image.value?.path ?? '',
    };

    printf('<---json-body--->${jsonEncode(body)}');

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.checkInApi;

    if (await InternetConnection().hasInternetAccess) {
      showProgress();

      final String? imagePath = image.value?.path;
      final bool hasImage = imagePath != null && imagePath.isNotEmpty;

      final url =
          '$baseUrl$endpoint?flag=INSERT&CPMClientID=1&CPMUserName=Call&AttendanceEventList=${jsonEncode(body)}&FilePath=${hasImage ? imagePath : ''}';

      printf('<---url-->$url');

      final dio = dio_.Dio();
      dio_.FormData? formData;

      if (hasImage) {
        final fileName = imagePath.split('/').last;
        formData = dio_.FormData.fromMap({
          'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
            imagePath,
            filename: fileName,
          ),
        });

        debugPrint('📂 Image attached: $imagePath');
      } else {
        debugPrint('⚠️ No image attached, sending request without file.');
      }

      final response =
          hasImage ? await dio.post(url, data: formData) : await dio.post(url);

      printf('<---response--->$response');
      final messageText = response.data['MessageText'];
      if (response.data['Message'] == "Success") {
        hideProgress();
        Get.back(result: true);
        dropDownBannerSuccess(messageText);
      } else {
        hideProgress();
        dropDownBannerError(messageText);
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<bool> timeEventUpdateApi({
    required String clientId,
    required String userName,
    required String type,
    required String checkInId,
  }) async {
    printf('<--timeEventUpdateApi-clientId-$clientId--userName-->$userName');
    final DateTime nowUtc = DateTime.now().toUtc();
    final String createdDate = nowUtc.toIso8601String();
    Map<String, dynamic> body = {
      "CheckInId": checkInId,
      "EmployeeID": selectedEmpType.value,
      "CheckType": type,
      "InDate": selectedInDate.value,
      "ConvertedCheckinDate": convertedCheckInDate.value,
      "IsmanuallyDone": false,
      "CreatedDate": createdDate,
      "Latitude": latitude.value.toString(),
      "Longitude": longitude.value.toString(),
      "BusObjCode": "ATTEND_BUS_Attendance_Events",
      "PartnerType": selectedPartnerType.value,
    };

    printf('<---json-body--->${jsonEncode(body)}');

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.timeEventUpdateApi;

    if (await InternetConnection().hasInternetAccess) {
      showProgress();
      final String? imagePath = image.value?.path;
      final bool hasImage = imagePath != null && imagePath.isNotEmpty;
      final url =
          '$baseUrl$endpoint?flag=UPDATE&CPMClientID=1&CPMUserName=Call&AttendanceEventList=${jsonEncode(body)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      // File imageFile = File(image.value?.path ?? '');
      // String fileName = imageFile.path.split('/').last;
      // dio_.FormData formData = dio_.FormData.fromMap({
      //   'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
      //     imageFile.path,
      //     filename: fileName,
      //   ),
      // });
      //
      // final dio = dio_.Dio();
      // final response = await dio.post(url);

      final dio = dio_.Dio();
      dio_.FormData? formData;

      if (hasImage) {
        final fileName = imagePath.split('/').last;
        formData = dio_.FormData.fromMap({
          'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
            imagePath,
            filename: fileName,
          ),
        });

        debugPrint('📂 Image attached: $imagePath');
      } else {
        debugPrint('⚠️ No image attached, sending request without file.');
      }

      final response =
          hasImage ? await dio.post(url, data: formData) : await dio.post(url);

      printf('<---response--timeEventUpdateApi->$response');

      if (response.data['Message'] == "Success") {
        // final messageText = response.data['MessageText'];
        // dropDownBannerSuccess(messageText);
        return true;
      } else {
        // final messageText = response.data['MessageText'];
        // dropDownBannerError(messageText);
        return false;
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
      return false;
    }
  }

  void buttonCheckOut() {
    if (selectedEmpType.value.isEmpty) {
      dropDownBannerError('select employee');
    } else if (selectedPartnerType.value.isEmpty) {
      dropDownBannerError('select employee type');
    } else {
      printf(
        'emp->${selectedEmpType.value} date->${defaultDate.value} time->${defaultTime.value}',
      );
      printf(
        'checkTime->${timeNow(defaultTime.value).toString()} lati->$latitude long->$longitude',
      );
      printf(
        'file->$pickedImagePath partnertype->${selectedPartnerType.value}',
      );

      checkOutApi(
        clientId: clientId,
        userName: userName,
        type: 'O',
        editId: checkInId,
      );

      printf('<---call-check-in/out--->');
    }
  }

  Future<void> checkOutApi({
    required String clientId,
    required String userName,
    required String type,
    required String editId,
  }) async {
    printf('<--checkOutApi-clientId-$clientId--userName-->$userName');

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.checkOutApi;

    if (await InternetConnection().hasInternetAccess) {
      showProgress();
      final url =
          '$baseUrl$endpoint?AttendEventID=$editId&CPMClientID=1&CPMUserName=Call'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      File imageFile = File(image.value?.path ?? '');
      String fileName = imageFile.path.split('/').last;
      dio_.FormData formData = dio_.FormData.fromMap({
        'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final dio = dio_.Dio();
      final response = await dio.post(url, data: formData);
      printf('<---response--->$response');
      final Map<String, dynamic> json =
          response.data is String ? jsonDecode(response.data) : response.data;

      final serviceStatus = jsonDecode(json['ServiceStatus']);
      if (serviceStatus['MessageDescription'] == "Success") {
        hideProgress();
        Get.back(result: true);
        dropDownBannerSuccess('Success');
      } else {
        dropDownBannerSuccess(serviceStatus['MessageDescription']);
      }
      hideProgress();
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> getCurrentLocation1() async {
    String location = "Fetching...";
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location = "Location services are disabled.";
      update();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        location = "Location permission denied.";
        update();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      location = "Location permissions are permanently denied.";
      update();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude.value = position.latitude;
    longitude.value = position.longitude;

    location =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    update();

    printf("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }

  Future<void> getCurrentLocation2() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        latitude.value = 28.6139;
        longitude.value = 77.2090;
        printf("⚠️ Location services disabled. Using fallback location.");
        update();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          latitude.value = 28.6139;
          longitude.value = 77.2090;
          printf("⚠️ Location permission denied. Using fallback location.");
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        latitude.value = 28.6139;
        longitude.value = 77.2090;
        printf(
          "⚠️ Location permission permanently denied. Using fallback location.",
        );
        update();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      printf(
        "✅ Got location: Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
      update();
    } catch (e) {
      latitude.value = 28.6139;
      longitude.value = 77.2090;
      printf("❌ Error while getting location: $e. Using fallback.");
      update();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      // 1️⃣ Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        printf("⚠️ Location services are disabled. Opening settings...");

        // 2️⃣ Open location settings
        bool opened = await Geolocator.openLocationSettings();

        // 3️⃣ Wait a few seconds and check again
        await Future.delayed(const Duration(seconds: 3));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          // 4️⃣ If still disabled → use fallback location
          latitude.value = 28.6139;
          longitude.value = 77.2090;
          printf("Location still disabled. Using fallback location.");
          update();
          return;
        }
      }

      // 5️⃣ Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // 6️⃣ Permission denied → fallback
          latitude.value = 28.6139;
          longitude.value = 77.2090;
          printf("Location permission denied. Using fallback location.");
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // 7️⃣ Permission permanently denied → fallback
        latitude.value = 28.6139;
        longitude.value = 77.2090;
        printf(
          "Location permission permanently denied. Using fallback location.",
        );
        update();
        return;
      }

      // 8️⃣ Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      printf(
        "✅ Got location: Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
      update();
    } catch (e) {
      latitude.value = 28.6139;
      longitude.value = 77.2090;
      printf("❌ Error while getting location: $e. Using fallback.");
      update();
    }
  }
}
