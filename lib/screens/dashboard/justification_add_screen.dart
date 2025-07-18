import 'package:crysprsys/controllers/dashboard/justification_add_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/justification/justification_drop_down.dart';
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
            title: Text(
              "Create Justification",
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
                  buildEditableField(
                    label: 'Justification No',
                    controller: controller.textJustificationNo,
                    maxLine: 1,
                    inputType: TextInputType.number
                  ),
                  Obx(() {
                    return buildDropdownFieldUpdate<PartnerType>(
                      label: 'Select Partner Type',
                      selectedItem: controller.selectedPartnerType.value,
                      items: controller.partnerTypeList,
                      itemLabelBuilder: (item) => item.value,
                      onChanged: (newValue) {
                        controller.selectedPartnerType.value = newValue!;
                      },
                    );
                  }),
                  Obx(() {
                    return buildDropdownFieldUpdate<AuthEmployee>(
                      label: 'Select Employee',
                      selectedItem: controller.selectedPersonalNumber.value,
                      items: controller.personalNumberList,
                      itemLabelBuilder: (item) => item.description,
                      onChanged: (newValue) {
                        controller.selectedPersonalNumber.value = newValue!;
                      },
                    );
                  }),
                  Obx(() {
                    return buildDropdownFieldUpdate<ViolationTypeData>(
                      label: 'Select Violation Type',
                      selectedItem: controller.selectedViolationType.value,
                      items: controller.violationTypeDataList,
                      itemLabelBuilder: (item) => item.value,
                      onChanged: (newValue) {
                        ViolationTypeData? data = newValue;
                        controller.selectedViolationType.value = data;
                        controller.changeType(newValue!);
                      },
                    );
                  }),
                  buildReadOnlyField("Violation Date", "05/02/2025"),
                  buildEditableField(
                    label: 'Time in',
                    controller: controller.textTimeIn,
                    maxLine: 1,
                    onTap: () {
                      printf('clicked-time-in');
                      controller.selectTime(context, 'in');
                    },
                    enable: false,
                  ),
                  Obx(() {
                    return controller.isShowTimeOut.value
                        ? buildEditableField(
                          label: 'Time out',
                          controller: controller.textTimeOut,
                          maxLine: 1,
                          onTap: () {
                            printf('clicked-time-in');
                            controller.selectTime(context, 'out');
                          },
                          enable: false,
                        )
                        : SizedBox();
                  }),
                  Obx(() {
                    return DropdownButtonFormField<int>(
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
                    );
                  }),
                  const SizedBox(height: 16),
                  buildEditableField(
                    label: 'Status',
                    controller: controller.textStatus,
                    maxLine: 1,
                  ),
                  buildEditableField(
                    label: 'Pending with',
                    controller: controller.textPendingWith,
                    maxLine: 1,
                  ),
                  buildEditableField(
                    label: 'Justification Reason',
                    controller: controller.textJustificationReason,
                    maxLine: 3,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          horizontalMargin: 0,
                          icon: "",
                          text: 'Save'.toUpperCase(),
                          onPressed: () {
                            controller.buttonCreateJustification();
                          },
                        ),
                      ),
                      10.sbw,
                      Expanded(
                        child: CustomButton(
                          horizontalMargin: 0,
                          icon: "",
                          text: 'Cancel'.toUpperCase(),
                          onPressed: () {},
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
        GestureDetector(
          onTap: onTap,
          child: TextFormField(
            controller: controller,
            enabled: enable,
            maxLines: maxLine,
            keyboardType: inputType,
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
