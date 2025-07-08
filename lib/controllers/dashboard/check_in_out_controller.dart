import 'dart:convert';
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

  var selectedAuthId = ''.obs;
  RxList<Map<String, String>> dropdownItems = <Map<String, String>>[].obs;

  var selectedPartnerType = ''.obs;
  RxList<Map<String, String>> partnerDropdownItems =
      <Map<String, String>>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm:ss');

  // Reactive formatted strings
  RxString defaultDate = ''.obs;
  RxString defaultTime = ''.obs;

  late final UserSettingsModel userSettingsTimeZone;

  var latitude = '';
  var longitude = '';

  var from = AppConstants.add;
  var checkInId = '';

  RxString selectedInDate = ''.obs;
  RxString convertedCheckInDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--CheckInOutController----->');

    try {
      from = Get.arguments['from'] ?? AppConstants.add;
      checkInId = Get.arguments['checkInId'];
      printf('<---from---->$from--check-in-id-->$checkInId');
    } catch (e) {
      printf('exe-from-->$e');
    }

    // Format and store the default date
    defaultDate.value = dateFormat.format(selectedDate.value);

    // Store UTC ISO string for selected date
    selectedInDate.value = selectedDate.value.toUtc().toIso8601String();

    // Get location
    getCurrentLocation();

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
    getUserTimeZoneApi(clientId: clientId, userName: userName).whenComplete(() {
      getDropDownListApi(clientId: clientId, userName: userName);
    });
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

      final isToday =
          selectedDate.value.year == now.year &&
          selectedDate.value.month == now.month &&
          selectedDate.value.day == now.day;

      if (isToday && pickedDateTime.isAfter(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cannot select future time for today's date."),
          ),
        );
        return;
      }

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

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
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

        print('Full URL: ${uri.toString()}');

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

          dropdownItems.value =
              model.authBasedObjectsList.map((e) {
                return {'id': e.id ?? '', 'label': e.description ?? ''};
              }).toList();

          partnerDropdownItems.value =
              model.partnerTypeList.map((e) {
                return {'id': e.id ?? '', 'label': e.value ?? ''};
              }).toList();

          if (partnerDropdownItems.isNotEmpty) {
            selectedPartnerType.value = partnerDropdownItems.first['id'] ?? '';
          }

          if (dropdownItems.isNotEmpty) {
            selectedAuthId.value = dropdownItems.first['id'] ?? '';
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
    if (pickedImagePath.value.isEmpty) {
      dropDownBannerError('Upload image');
    } else if (selectedAuthId.value.isEmpty) {
      dropDownBannerError('select patner type');
    } else if (selectedPartnerType.value.isEmpty) {
      dropDownBannerError('select employe type');
    } else {
      printf(
        'emp->${selectedAuthId.value} date->${defaultDate.value} time->${defaultTime.value}',
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
      "EmployeeID": selectedAuthId.value,
      "CheckType": type,
      "InDate": selectedInDate.value,
      "ConvertedCheckinDate": convertedCheckInDate.value,
      //"Checktime": timeNow(defaultTime.value).toString(),
      "IsmanuallyDone": false,
      "CreatedDate": createdDate,
      "Latitude": latitude,
      "Longitude": longitude,
      "BusObjCode": "ATTEND_BUS_Attendance_Events",
      "PartnerType": selectedPartnerType.value,
    };

    printf('<---json-body--->${jsonEncode(body)}');

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.checkInApi;

    if (await InternetConnection().hasInternetAccess) {
      showProgress();
      final url =
          '$baseUrl$endpoint?flag=INSERT&CPMClientID=1&CPMUserName=Call&AttendanceEventList=${jsonEncode(body)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      File imageFile = File(image.value!.path);
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

  void buttonCheckOut() {
    if (pickedImagePath.value.isEmpty) {
      dropDownBannerError('Upload image');
    } else if (selectedAuthId.value.isEmpty) {
      dropDownBannerError('select patner type');
    } else if (selectedPartnerType.value.isEmpty) {
      dropDownBannerError('select employe type');
    } else {
      printf(
        'emp->${selectedAuthId.value} date->${defaultDate.value} time->${defaultTime.value}',
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

      File imageFile = File(image.value!.path);
      String fileName = imageFile.path.split('/').last;
      dio_.FormData formData = dio_.FormData.fromMap({
        'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final dio = dio_.Dio();
      final response = await dio.post(url);
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
      "EmployeeID": selectedAuthId.value,
      "CheckType": type,
      "InDate": selectedInDate.value,
      "ConvertedCheckinDate": convertedCheckInDate.value,
      "IsmanuallyDone": false,
      "CreatedDate": createdDate,
      "Latitude": latitude,
      "Longitude": longitude,
      "BusObjCode": "ATTEND_BUS_Attendance_Events",
      "PartnerType": selectedPartnerType.value,
    };

    printf('<---json-body--->${jsonEncode(body)}');

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.timeEventUpdateApi;

    if (await InternetConnection().hasInternetAccess) {
      showProgress();
      final url =
          '$baseUrl$endpoint?flag=UPDATE&CPMClientID=1&CPMUserName=Call&AttendanceEventList=${jsonEncode(body)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      File imageFile = File(image.value!.path);
      String fileName = imageFile.path.split('/').last;
      dio_.FormData formData = dio_.FormData.fromMap({
        'AttendanceUserProfilePic': await dio_.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final dio = dio_.Dio();
      final response = await dio.post(url);

      printf('<---response--->$response');

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

  Future<void> getCurrentLocation() async {
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

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    location =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    update();

    printf("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }
}
