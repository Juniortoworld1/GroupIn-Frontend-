import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../provider/Global.dart';

class AnimatedLogo extends StatefulWidget {
  final double top;
  final double defaultTop;
  final double defaultBottom;
  final double defaultLeft;
  final double defaultRight;
  final double bottom;
  final double left;
  final double right;
  final double height;
  final double width;
  final Color CircleColor;
  final Icon CircleIcon;

  const AnimatedLogo({
    super.key,
    required this.top,
    required this.defaultTop,
    required this.defaultBottom,
    required this.defaultLeft,
    required this.defaultRight,
    required this.bottom,
    required this.left,
    required this.right,
    required this.height,
    required this.width,
    required this.CircleColor,
    required this.CircleIcon,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          _isAnimated = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Note: Cast to double to match your width parameters and container layout
    final double calculatedWidth = (kIsWeb ? widget.width : screenWidth * widget.width).toDouble();

    return Consumer<GlobalValueProvider>(builder: (ctx, _, __) {
      return AnimatedPositioned(
        top: _isAnimated ? widget.top : widget.defaultTop,
        left: _isAnimated ? widget.left : widget.defaultLeft,
        right: _isAnimated ? widget.right : widget.defaultRight,
        bottom: _isAnimated ? widget.bottom : widget.defaultBottom,
        duration: const Duration(seconds: 3),
        onEnd: () {
          if (mounted) {
            setState(() {
              _isAnimated = !_isAnimated;
            });
          }
        },
        // 1. Wrap with Align to prevent the Positioned widget from stretching the child
        child: Align(
          alignment: Alignment.center,
          child: Container(
            // 2. Use your dynamic calculatedWidth and height variables instead of hardcoded 10
            width: calculatedWidth,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.CircleColor,
              shape: BoxShape.circle,
            ),
            child: widget.CircleIcon,
          ),
        ),
      );
    });
  }
}
