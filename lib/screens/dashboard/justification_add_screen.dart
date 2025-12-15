import 'package:crysprsys/controllers/dashboard/justification_add_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/justification/justification_drop_down.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/custom_button.dart';

class JustificationAddScreen extends StatefulWidget {
  const JustificationAddScreen({super.key});

  @override
  State<JustificationAddScreen> createState() => _JustificationAddScreenState();
}

class _JustificationAddScreenState extends State<JustificationAddScreen> {
  final JustificationAddController controller =
      Get.find<JustificationAddController>();

  // Example dropdown values
  String? partnerType = 'Employee';
  String? personalNumber = '1007-Harish Narakuduru';
  String? violationType = 'Late Coming';
  String? requestType = 'Personal';

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
            title: Obx(() {
              return Text(
                controller.title.value,
                style: interTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),
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
                        label: 'Justification No',
                        controller: controller.textJustificationNo,
                        enable: true,
                        maxLine: 1,
                        inputType: TextInputType.number,
                      ),
                  Obx(() {
                    return IgnorePointer(
                      ignoring: controller.isFromNotification.value,
                      child: buildDropdownFieldUpdate<PartnerType>(
                        label: 'Select Partner Type',
                        selectedItem: controller.selectedPartnerType.value,
                        items: controller.partnerTypeList,
                        itemLabelBuilder: (item) => item.value,
                        onChanged: (newValue) {
                          controller.selectedPartnerType.value = newValue!;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return IgnorePointer(
                      ignoring: controller.isFromNotification.value,
                      child: buildDropdownFieldUpdate<AuthEmployee>(
                        label: 'Select Employee',
                        selectedItem: controller.selectedPersonalNumber.value,
                        items: controller.personalNumberList,
                        itemLabelBuilder: (item) => item.description,
                        onChanged: (newValue) {
                          controller.selectedPersonalNumber.value = newValue!;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return IgnorePointer(
                      ignoring: controller.isFromNotification.value,
                      child: buildDropdownFieldUpdate<ViolationTypeData>(
                        label: 'Select Violation Type',
                        selectedItem: controller.selectedViolationType.value,
                        items: controller.violationTypeDataList,
                        itemLabelBuilder: (item) => item.value,
                        onChanged: (newValue) {
                          ViolationTypeData? data = newValue;
                          controller.selectedViolationType.value = data;
                          controller.changeType(newValue!);
                        },
                      ),
                    );
                  }),
                  IgnorePointer(
                    ignoring: controller.isFromNotification.value,
                    child: buildEditableField(
                      label: 'Violation Date',
                      controller: controller.textViolationDate,
                      maxLine: 1,
                      onTap: () {
                        printf('clicked-violation-date');
                        controller.selectDate(context);
                      },
                      enable: true,
                    ),
                  ),
                  Obx(() {
                    return controller.isShowTimeIn.value
                        ? IgnorePointer(
                          ignoring: controller.isFromNotification.value,
                          child: buildEditableField(
                            label: 'Time in',
                            controller: controller.textTimeIn,
                            maxLine: 1,
                            onTap: () {
                              printf('clicked-time-in');
                              controller.selectTime(context, 'in');
                            },
                            enable: true,
                          ),
                        )
                        : SizedBox();
                  }),

                  Obx(() {
                    return controller.isShowTimeOut.value
                        ? IgnorePointer(
                          ignoring: controller.isFromNotification.value,
                          child: buildEditableField(
                            label: 'Time out',
                            controller: controller.textTimeOut,
                            maxLine: 1,
                            onTap: () {
                              printf('clicked-time-in');
                              controller.selectTime(context, 'out');
                            },
                            enable: true,
                          ),
                        )
                        : SizedBox();
                  }),
                  Obx(() {
                    return IgnorePointer(
                      ignoring: controller.isFromNotification.value,
                      child: DropdownButtonFormField<int>(
                        value: controller.selectedRequestType.value,
                        items:
                            controller.requestTypeMap.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            controller.selectedRequestType.value = newValue;
                          }
                        },
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
                    );
                  }),
                  const SizedBox(height: 16),
                  controller.from == AppConstants.edit ||
                          controller.from == 'Notification'
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildEditableField(
                            label: 'Status',
                            controller: controller.textStatus,
                            maxLine: 1,
                            enable: true,
                          ),
                          buildEditableField(
                            label: 'Pending with',
                            controller: controller.textPendingWith,
                            maxLine: 1,
                            enable: true,
                          ),
                        ],
                      )
                      : SizedBox(),
                  IgnorePointer(
                    ignoring: controller.isFromNotification.value,
                    child: buildEditableField(
                      label: 'Justification Reason',
                      controller: controller.textJustificationReason,
                      maxLine: 3,
                      enable: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  controller.from == AppConstants.view
                      ? SizedBox()
                      : controller.from == 'Notification'
                      ? Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              horizontalMargin: 0,
                              icon: "",
                              text: 'Approve'.toUpperCase(),
                              onPressed: () {
                                // controller.buttonApproveRejectNotification(
                                //   'Approval',
                                // );
                                controller.buttonApproveReject('Approval');
                              },
                            ),
                          ),
                          10.sbw,
                          Expanded(
                            child: CustomButton(
                              horizontalMargin: 0,
                              icon: "",
                              text: 'Reject'.toUpperCase(),
                              onPressed: () {
                                // controller.buttonApproveRejectNotification(
                                //   'Rejected',
                                // );
                                controller.buttonApproveReject('Rejected');
                              },
                            ),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              horizontalMargin: 0,
                              icon: "",
                              text: 'Save'.toUpperCase(),
                              onPressed: () {
                                if (controller.from == AppConstants.edit) {
                                  controller.buttonUpdateJustification('save');
                                } else {
                                  controller.buttonCreateJustification('save');
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
                                  controller.buttonUpdateJustification(
                                    'submit',
                                  );
                                } else {
                                  controller.buttonCreateJustification(
                                    'submit',
                                  );
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
    bool enable = true,
    TextInputType inputType = TextInputType.text,
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
          onTap: onTap,
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
}
