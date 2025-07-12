import 'package:cached_network_image/cached_network_image.dart';
import 'package:crysprsys/controllers/dashboard/face_registration_list_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceRegistrationListScreen extends StatelessWidget {
  FaceRegistrationListScreen({super.key});

  final FaceRegistrationListController controller =
      Get.find<FaceRegistrationListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "Face Registration List",
          style: interTextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        // actions: [
        //   Icon(Icons.notifications, color: Colors.white),
        //   SizedBox(width: 8),
        //   Icon(Icons.search),
        //   SizedBox(width: 10),
        // ],
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Obx(() {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 100),
              itemCount: controller.faceUserList.length,
              itemBuilder: (context, index) {
                final emp = controller.faceUserList[index];
                return Card(
                  elevation: 1,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 96,
                        width: 90,
                        child: CachedNetworkImage(
                          imageUrl: emp.attendanceUserUImage,
                          placeholder:
                              (context, url) => Center(
                                child: SizedBox(
                                  height: 24, // Adjust size as needed
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ), // Thinner circle
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                          fit:
                              BoxFit
                                  .cover, // Optional: scale image to fill container
                        ),
                      ),
                      5.sbw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Employee/User",
                              style: interTextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                size: 12.sp,
                              ),
                            ),
                            Text(
                              emp.objectNo,
                              style: interTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                size: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widgetContainer(
                              icon: Icons.delete,
                              bgColors: ColorConstants.appColor,
                              borderColor: ColorConstants.appColor,
                              iconColor: Colors.white,
                              onTap: () {
                                controller.showDeleteFaceIdDialog(
                                  emp.faceRegID,
                                );
                              },
                            ),
                            10.sbw,
                            widgetContainer(
                              icon: Icons.edit,
                              bgColors: ColorConstants.appColor,
                              borderColor: ColorConstants.appColor,
                              iconColor: Colors.white,
                              onTap: () async {
                                final result = await Get.toNamed(
                                  Routes.faceRegistrationScreen,
                                  arguments: {
                                    'from': AppConstants.edit,
                                    'id': emp.faceRegID,
                                    'faceId': emp.faceId,
                                  },
                                );

                                if (result) {
                                  controller.getFaceUserListApi(
                                    clientId: controller.clientId,
                                    userName: controller.userName,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed(
            Routes.faceRegistrationScreen,
            arguments: {'from': AppConstants.add},
          );
          if (result) {
            controller.getFaceUserListApi(
              clientId: controller.clientId,
              userName: controller.userName,
            );
          }
        }, // Change icon if needed
        backgroundColor: ColorConstants.appColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white), // Optional
      ),
    );
  }
}
