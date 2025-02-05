import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum AnimationType { fade, rotate, scale, slide, size, switcher, none }

class SmartOverlay extends HookWidget {
  final Widget Function(VoidCallback openOverlay) child;
  final Widget Function(VoidCallback closeOverlay) overlayContent;
  final Color? backgroundColor;
  final int? horizontalPadding;
  final int? verticalPadding;
  final VoidCallback? onOpened;
  final bool blurBackground;
  final double? blurOpacity;
  final Duration animationDuration;
  final Curve animationCurve;
  final AnimationType animationType;

  const SmartOverlay({super.key, required this.child, required this.overlayContent, this.backgroundColor, this.horizontalPadding, this.verticalPadding, this.onOpened, this.blurBackground = false, this.blurOpacity, this.animationDuration = const Duration(milliseconds: 300), this.animationCurve = Curves.easeInOut, this.animationType = AnimationType.none});

  @override
  Widget build(BuildContext context) {
    final overlayEntry = useState<OverlayEntry?>(null);
    final animationController = useAnimationController(duration: animationDuration);
    final animation = CurvedAnimation(parent: animationController, curve: animationCurve);

    final removeOverlay = useCallback(() {
      if (overlayEntry.value != null) {
        animationController.reverse().then((_) {
          overlayEntry.value?.remove();
          overlayEntry.value = null;
        });
      }
    }, [overlayEntry, animationController]);

    useEffect(() {
      return () {
        removeOverlay();
      };
    }, [removeOverlay]);

    Widget buildAnimatedOverlay(Widget content) {
      switch (animationType) {
        case AnimationType.fade:
          return FadeTransition(opacity: animation, child: content);
        case AnimationType.rotate:
          return RotationTransition(turns: animation, child: content);
        case AnimationType.scale:
          return ScaleTransition(scale: animation, child: content);
        case AnimationType.slide:
          return SlideTransition(position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation), child: content);
        case AnimationType.size:
          return SizeTransition(sizeFactor: animation, axis: Axis.vertical, child: content);
        case AnimationType.switcher:
          return AnimatedSwitcher(duration: animationDuration, switchInCurve: animationCurve, switchOutCurve: animationCurve, child: content);
        case AnimationType.none:
          return content;
      }
    }

    final showOverlay = useCallback(() {
      if (overlayEntry.value != null) return;

      if (onOpened != null) onOpened!();

      final overlay = Overlay.of(context);
      final renderBox = context.findRenderObject() as RenderBox?;
      final offset = renderBox?.localToGlobal(Offset.zero);
      final horizontalPadding = this.horizontalPadding ?? 0;
      final verticalPadding = this.verticalPadding ?? 0;

      final newOverlayEntry = OverlayEntry(
          builder: (context) => Stack(children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => removeOverlay(),
                    behavior: HitTestBehavior.opaque,
                    child: blurBackground ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), child: Container(color: Colors.black.withOpacity(blurOpacity ?? 0.2))) : Container(color: Colors.transparent),
                  ),
                ),
                Positioned(left: offset!.dx - horizontalPadding, top: offset.dy - verticalPadding, child: GestureDetector(onTap: () {}, child: Material(color: backgroundColor ?? Colors.transparent, child: buildAnimatedOverlay(overlayContent(removeOverlay)))))
              ]));

      overlay.insert(newOverlayEntry);
      overlayEntry.value = newOverlayEntry;
      animationController.forward();
    }, [overlayEntry, onOpened, backgroundColor, blurBackground, blurOpacity, horizontalPadding, verticalPadding, overlayContent, removeOverlay, animationController]);

    return child(showOverlay);
  }
}
