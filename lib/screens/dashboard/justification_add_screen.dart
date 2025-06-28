import 'package:crysprsys/controllers/dashboard/justification_add_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:crysprsys/helper/common.dart';
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
                buildEditableField("Justification No", "1000000128",1),
                buildDropdownField("Partner Type", partnerType, ['Employee', 'Contractor'], (val) {
                  setState(() => partnerType = val);
                }),
                buildDropdownField("Personal Number", personalNumber,
                    ['1007-Harish Narakuduru', '1008-Rajesh Kumar'], (val) {
                      setState(() => personalNumber = val);
                    }),
                buildDropdownField("Violation Type", violationType,
                    ['Late Coming', 'Early Going'], (val) {
                      setState(() => violationType = val);
                    }),
                buildReadOnlyField("Violation Date", "05/02/2025"),
                buildReadOnlyField("Time in", "10:57"),
                buildDropdownField("Request Type", requestType,
                    ['Personal', 'Official'], (val) {
                      setState(() => requestType = val);
                    }),
                buildReadOnlyField("Status", "Submitted"),
                buildReadOnlyField("Pending with",
                    "vikram - Vikram - vilas.vikram@gmail.com"),
                buildEditableField("Justification Reason", "Going out",3),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        horizontalMargin: 0,
                        icon: "",
                        text: 'Save'.toUpperCase(),
                        onPressed: () {},
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
    );
  }

  Widget buildDropdownField(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
        Text(label,
            style: TextStyle(
                color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: true,
          initialValue: value,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildEditableField(String label, String value,int maxLine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          maxLines: maxLine,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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