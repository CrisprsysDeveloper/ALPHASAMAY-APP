import 'dart:convert';
import 'dart:io';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

import '../../model/dashboard/checkin_checkout_type_model.dart';




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


// Existing
  RxList<Map<String, String>> dropdownItems = <Map<String, String>>[].obs; // AttendanceUserList
  RxList<Map<String, String>> partnerDropdownItems = <Map<String, String>>[].obs; // BusinessObjectsList
  RxString selectedAuthId = ''.obs; // Object Number
  RxString selectedPartnerType = ''.obs; // Business Object

// ✅ Add this:
  RxList<Map<String, String>> filteredObjectNumbers = <Map<String, String>>[].obs;
  RxString selectedObjectNumber = ''.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm:ss');

  // Reactive formatted strings
  RxString defaultDate = ''.obs;
  RxString defaultTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--CheckInOutController----->');
    defaultDate.value = dateFormat.format(selectedDate.value);

    getCurrentLocation();
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
    ValueNotifier<String> authEventType = ValueNotifier('');

    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getGetFaceRekognitionScreenDataApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'BusObjCode': 'CRIS_BUS_GS_FaceRegistration _NT',
            'SMode': 'Create',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        printf('<----response---->${response.data}');

        // First-level decoding
        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        final Map<String, dynamic> serviceStatus =
        jsonDecode(outerJson['ServiceStatus']);

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          /// Parse the actual dropdown data
          final List<dynamic> businessObjectsRaw =
          jsonDecode(outerJson['BusinessObjectsList']);

          final List<dynamic> attendanceUsersRaw =
          jsonDecode(outerJson['AttendanceUserList']);

          /// Map to UI dropdowns
          partnerDropdownItems.value = businessObjectsRaw
              .map<Map<String, String>>((e) => {
            'id': e['ID'] ?? '',
            'label': e['Value'] ?? '',
          })
              .toList();

          dropdownItems.value = attendanceUsersRaw
              .map<Map<String, String>>((e) => {
            'id': e['ID'] ?? '',
            'label': e['Description'] ?? '',
            'ptype': e['PType'] ?? '',
          })
              .toList();

          /// Set default selections
          if (partnerDropdownItems.value.isNotEmpty) {
            selectedPartnerType.value = partnerDropdownItems.value.first['id']!;
          }

          if (dropdownItems.value.isNotEmpty) {
            selectedAuthId.value = dropdownItems.value.first['id']!;
          }

          /// Save AuthEventType if needed
          authEventType.value = outerJson['AuthEventType'] ?? '';

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


  void filterObjectNumbersByPType() {
    final selectedPType = selectedPartnerType.value;
    filteredObjectNumbers.value = dropdownItems
        .where((item) => item['ptype'] == selectedPType)
        .toList();

    // Optionally preselect the first object number
    if (filteredObjectNumbers.isNotEmpty) {
      selectedObjectNumber.value = filteredObjectNumbers.first['id'] ?? '';
    } else {
      selectedObjectNumber.value = '';
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
    // Step 1: Validate input
    if (selectedPartnerType.value.isEmpty || selectedObjectNumber.value.isEmpty) {
      Utility.showToastMessage("Please select Business Object and Object Number");
      return;
    }

    if (pickedImagePath.value.isEmpty) {
      Utility.showToastMessage("Please take a photo");
      return;
    }

    final Dio dio = Dio();
    final String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.saveMobileAttendanceUserProfileApi;

    // Step 2: Build query parameters
    final Map<String, String> queryParams = {
      'CPMClientID': clientId,
      'CPMUserName': userName,
      'BusObjCode': selectedPartnerType.value,
      'ObjectNumber': selectedObjectNumber.value,
      'FilePath': pickedImagePath.value,
    };

    print(queryParams);
    /*// Include FaceId only if in Edit mode
    if (type == 'Edit' && faceId != null && faceId!.isNotEmpty) {
      queryParams['FaceId'] = faceId!;
    }*/

    try {
      showProgress();
      print(baseUrl+endpoint);

      // Step 3: Prepare file for upload
      final file = await MultipartFile.fromFile(
        pickedImagePath.value,
        filename: pickedImagePath.value.split('/').last,
      );

      final formData = FormData.fromMap({
        'AttendanceUserProfilePic': file,
      });

      // Step 4: Make POST request
      final response = await dio.post(
        '$baseUrl$endpoint',
        queryParameters: queryParams,
        data: formData,
      );
      hideProgress();

      // Step 5: Parse response
      final result = jsonDecode(response.data);
      final status = jsonDecode(result['ServiceStatus']);

      if (status['MessageCode'] == "200") {
        final successMessage = "Face Registration Completed Successfully";

        Utility.showToastMessage(successMessage);
        Get.back(result: true); // return to previous screen
      } else {
        Utility.showToastMessage(status['MessageDescription'] ?? "Failed");
      }
    } catch (e) {
      hideProgress();
      Utility.showToastMessage("Something went wrong");
      print("Registration Exception: $e");
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

    location =
    "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    update();

    printf("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }
}