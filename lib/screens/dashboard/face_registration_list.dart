import 'package:crysprsys/controllers/dashboard/face_registration_list_controller.dart';
import 'package:crysprsys/helper/common.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Face Registration List",
          style: interTextStyle(color: Colors.white),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 8),
          Icon(Icons.search),
          SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(color: Colors.grey, height: 95.h, width: 95.w),
                Expanded(child: Column()),
                Row(
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
    );
  }
}
