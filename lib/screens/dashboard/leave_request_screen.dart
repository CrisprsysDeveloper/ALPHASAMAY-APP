import 'package:crysprsys/controllers/dashboard/justification_add_controller.dart';
import 'package:crysprsys/controllers/dashboard/leave_request_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/leave/leave_request_dropdown.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/widgets/custom_button.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final LeaveRequestController controller = Get.find<LeaveRequestController>();

  // Example dropdown values
  String? partnerType = 'Employee';
  String? personalNumber = '1007-Harish Narakuduru';
  String? violationType = 'Late Coming';
  String? requestType = 'Annual Leave';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ColorConstants.appColor,
            title: Text(
              "Leave Request",
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
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  controller.from == AppConstants.add
                      ? SizedBox()
                      : buildEditableField(
                        label: 'Leave Id',
                        enable: false,
                        controller: controller.textLeaveId,
                        maxLine: 1,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // only 0–9 allowed
                        ],
                      ),
                  Obx(() {
                    return buildDropdownFieldUpdate<Employee>(
                      label: 'Employee No',
                      selectedItem: controller.selectedEmployee.value,
                      items: controller.employeesList,
                      itemLabelBuilder: (item) => item.value,
                      onChanged: (newValue) {
                        controller.selectedEmployee.value = newValue!;
                      },
                    );
                  }),
                  buildEditableField(
                    label: 'Leave Start Date',
                    controller: controller.textLeaveStartDate,
                    maxLine: 1,
                    onTap: () {
                      controller.selectStartDate(context);
                    },
                    enable: true,
                  ),
                  buildEditableField(
                    label: 'Leave End Date',
                    controller: controller.textLeaveEndDate,
                    maxLine: 1,
                    onTap: () {
                      controller.selectEndDate(context);
                    },
                    enable: true,
                  ),
                  Obx(() {
                    return buildDropdownFieldUpdate<LeaveType>(
                      label: 'Leave Type',
                      selectedItem: controller.selectedLeaveType.value,
                      items: controller.leaveTypesList,
                      itemLabelBuilder: (item) => item.value,
                      onChanged: (newValue) {
                        controller.selectedLeaveType.value = newValue!;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  controller.from == AppConstants.edit ||
                          controller.from == AppConstants.view
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildEditableField(
                            label: 'Status',
                            controller: controller.textLeaveStatus,
                            maxLine: 1,
                          ),
                          buildEditableField(
                            label: 'Pending with',
                            controller: controller.textPendingWith,
                            maxLine: 1,
                          ),
                        ],
                      )
                      : SizedBox(),
                  buildEditableField(
                    label: 'Leave Reason',
                    controller: controller.textLeaveReason,
                    maxLine: 3,
                  ),
                  const SizedBox(height: 20),
                  controller.from == AppConstants.view
                      ? SizedBox()
                      : Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              horizontalMargin: 0,
                              icon: "",
                              text: 'Save'.toUpperCase(),
                              onPressed: () {
                                if (controller.from == AppConstants.edit) {
                                  controller.buttonUpdateLeaveRequest('save');
                                } else {
                                  controller.buttonCreateLeaveRequest('save');
                                }
                              },
                            ),
                          ),
                          10.sbw,
                          Expanded(
                            child: CustomButton(
                              horizontalMargin: 0,
                              icon: "",
                              text: 'submit'.toUpperCase(),
                              onPressed: () {
                                if (controller.from == AppConstants.edit) {
                                  controller.buttonUpdateLeaveRequest('submit');
                                } else {
                                  controller.buttonCreateLeaveRequest('submit');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownFieldUpdate<T>({
    required String label,
    required T? selectedItem,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: selectedItem,
          items:
              items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabelBuilder(item)),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDropdownField(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items:
              items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: true,
          initialValue: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildEditableField({
    required String label,
    required TextEditingController controller,
    int? maxLine,
    VoidCallback? onTap,
    bool enable = false,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: enable,
          maxLines: maxLine,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          onTap: onTap,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
