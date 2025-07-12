import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({Key? key}) : super(key: key);

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  List<String> pin = [];
  List<String> confirmPin = [];
  bool isConfirming = false;

  final box = GetStorage();
  var setPin = '';

  @override
  void initState() {
    super.initState();
    printf('<----init----SetPinScreen---->');
    loadSavedCredentials();
  }

  void loadSavedCredentials() {
    final pin = box.read(AppConstants.prefPIN);

    if (pin != null) {
      setPin = pin;
    }
    printf('<---set-pin--->$pin');
  }

  void onKeyboardTap(String value) async {
    // Login mode (PIN already set)
    if (setPin.isNotEmpty) {
      if (pin.length < 4) {
        setState(() {
          pin.add(value);
        });

        if (pin.length == 4) {
          await Future.delayed(const Duration(milliseconds: 200));
          if (setPin == pin.join()) {
            printf('<---navigate-to-dashboard--->');
            Get.offAndToNamed(Routes.dashboardScreen);
          } else {
            Fluttertoast.showToast(
              msg: "Incorrect PIN",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            setState(() {
              pin.clear();
            });
          }
        }
      }
    }
    // Set new PIN mode
    else {
      if (!isConfirming) {
        if (pin.length < 4) {
          setState(() {
            pin.add(value);
          });

          if (pin.length == 4) {
            await Future.delayed(const Duration(milliseconds: 200));
            setState(() {
              isConfirming = true;
            });
          }
        }
      } else {
        if (confirmPin.length < 4) {
          setState(() {
            confirmPin.add(value);
          });

          if (confirmPin.length == 4) {
            if (pin.join() == confirmPin.join()) {
              String finalPin = pin.join();
              printf('<-----pin-set-----> $finalPin');

              Fluttertoast.showToast(
                msg: "PIN set successfully",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );

              await GetStorage().write(AppConstants.prefPIN, finalPin);
              Get.toNamed(Routes.dashboardScreen);
            } else {
              Fluttertoast.showToast(
                msg: "PINs do not match. Try again.",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );

              setState(() {
                pin.clear();
                confirmPin.clear();
                isConfirming = false;
              });
            }
          }
        }
      }
    }
  }


  void onBackspace() {
    setState(() {
      if (!isConfirming && pin.isNotEmpty) {
        pin.removeLast();
      } else if (isConfirming && confirmPin.isNotEmpty) {
        confirmPin.removeLast();
      }
    });
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
    final currentPin = isConfirming ? confirmPin : pin;

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
          setPin.isNotEmpty
              ? Text(
                'Please Enter PIN',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
              : Text(
                isConfirming ? 'Re-enter Your PIN' : 'Please Set Your PIN',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => pinIndicator(index < currentPin.length),
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
