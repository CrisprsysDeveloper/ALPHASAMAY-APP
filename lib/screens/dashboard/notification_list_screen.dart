import 'package:crysprsys/controllers/dashboard/notification_list_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationListScreen extends StatefulWidget {

  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final NotificationListController controller =
      Get.find<NotificationListController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: Text(
            "Notifications",
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
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return widgetNotificationItem(borderColor: Colors.orange);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetNotificationItem({borderColor}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 100.w,
                      child: Text(
                        'Notification No',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Sender',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '100899797979',
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Suresh-suresh',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 100.w,
                      child: Text(
                        'Application',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Business object',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '100899797979',
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Suresh-suresh',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 100.w,
                      child: Text(
                        'Notification Type',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'ObjectNo',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '100899797979',
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Suresh-suresh',
                      textAlign: TextAlign.end,
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Status',
                                style: interTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Created Date',
                                style: interTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Submitted',
                                style: interTextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Suresh-suresh',
                                style: interTextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50.w),
                  widgetContainer(
                    icon: Icons.add_alert_rounded,
                    bgColors: Colors.white,
                    borderColor: ColorConstants.appColor,
                    iconColor: ColorConstants.appColor,
                    onTap: () async {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
