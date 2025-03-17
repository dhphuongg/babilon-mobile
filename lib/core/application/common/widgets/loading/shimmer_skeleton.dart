import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  final double height;
  const ShimmerSkeleton({super.key, required this.height});

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!.withOpacity(_animation.value),
                Colors.grey[200]!.withOpacity(_animation.value),
                Colors.grey[300]!.withOpacity(_animation.value),
                Colors.grey[200]!.withOpacity(_animation.value),
                Colors.grey[300]!.withOpacity(_animation.value),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), // Animate opacity
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      },
    );
  }
}
