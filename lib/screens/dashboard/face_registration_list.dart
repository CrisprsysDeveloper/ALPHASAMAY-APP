import 'package:crysprsys/controllers/dashboard/face_registration_list_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
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
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return Card(
            elevation: 1,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(color: Colors.grey.shade300, height: 96, width: 90),
                Expanded(child: Column()),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widgetContainer(
                        icon: Icons.delete,
                        bgColors: ColorConstants.appColor,
                        borderColor: ColorConstants.appColor,
                        iconColor: Colors.white,
                        onTap: () {
                          printf('<---on-tap-delete--->');
                        },
                      ),
                      10.sbw,
                      widgetContainer(
                        icon: Icons.edit,
                        bgColors: ColorConstants.appColor,
                        borderColor: ColorConstants.appColor,
                        iconColor: Colors.white,
                        onTap: () {
                          printf('<---on-tap-edit--->');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  user['image']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                'Employee/User',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              subtitle: Text('${user['id']}-${user['name']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {},
                    color: Colors.deepPurple,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: CircleBorder(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                    color: Colors.deepPurple,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.faceRegistrationScreen);
        }, // Change icon if needed
        backgroundColor: ColorConstants.appColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white), // Optional
      ),
    );
  }
}
