import 'package:flutter/material.dart';

class ChildSizeNotifier extends StatelessWidget {
  final ValueNotifier<Size> notifier = ValueNotifier(const Size(0, 0));

  final Widget Function(BuildContext context, Size size, Widget? child) builder;
  final Widget? child;

  /// Global Key for the widget you want to get size
  final GlobalKey sizingChildKey;

  ChildSizeNotifier({
    Key? key,
    required this.builder,
    this.child,
    required this.sizingChildKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final BuildContext? context = sizingChildKey.currentContext;
      if (context == null) { return; }
      notifier.value = (context.findRenderObject() as RenderBox).size;
    });

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}