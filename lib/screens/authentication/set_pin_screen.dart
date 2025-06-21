import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({Key? key}) : super(key: key);

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  List<String> pin = [];

  void onKeyboardTap(String value) {
    if (pin.length < 4) {
      setState(() {
        pin.add(value);
        if (pin.length == 4) {
          String finalPin = pin.join(); // "4568"
          printf('<-----pin-set-----> $finalPin');
          Fluttertoast.showToast(
            msg: "PIN set successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Get.toNamed(Routes.dashboardScreen);
        }
      });
    }
  }

  void onBackspace() {
    if (pin.isNotEmpty) {
      setState(() => pin.removeLast());
    }
  }

  Widget pinIndicator(bool filled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white),
      ),
    );
  }

  Widget numberButton(String number) {
    return GestureDetector(
      onTap: () => onKeyboardTap(number),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget backspaceButton() {
    return GestureDetector(
      onTap: onBackspace,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: const Icon(Icons.backspace, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        elevation: 0,
        title: const Text('PIN', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please Set Your PIN',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => pinIndicator(index < pin.length),
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 12,
            padding: const EdgeInsets.symmetric(horizontal: 60),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              if (index == 9) return backspaceButton();
              if (index == 11) return const SizedBox.shrink();

              String number = index == 10 ? '0' : '${index + 1}';
              return numberButton(number);
            },
          ),
        ],
      ),
    );
  }
}
