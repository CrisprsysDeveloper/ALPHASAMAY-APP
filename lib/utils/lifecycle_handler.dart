import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? resumeCallBack;
  final Future<void> Function()? pausedCallBack;
  final Future<void> Function()? detachedCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.pausedCallBack,
    this.detachedCallBack,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) resumeCallBack!();
        break;
      case AppLifecycleState.paused:
        if (pausedCallBack != null) pausedCallBack!();
        break;
      case AppLifecycleState.detached:
        if (detachedCallBack != null) detachedCallBack!();
        break;
      case AppLifecycleState.inactive:
      // You can handle inactive if needed
        break;
      case AppLifecycleState.hidden:
        throw UnimplementedError();
    }
  }
}
