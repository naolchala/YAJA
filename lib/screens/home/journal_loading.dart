import 'dart:async';

import 'package:firebase_test/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_animations/simple_animations.dart';

class JournalLoading extends HookConsumerWidget {
  const JournalLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        return Shimmer(index);
      },
      childCount: 9,
    ));
  }
}

class Shimmer extends HookConsumerWidget {
  const Shimmer(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = ref.watch(ThemeModeProvider);
    return CustomAnimationBuilder(
      control: Control.mirror,
      tween: Tween(begin: 0.05, end: 1.0),
      curve: Curves.linearToEaseOut,
      duration: const Duration(seconds: 2),
      delay: Duration(milliseconds: 700 * index),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

// class Shimmer extends StatefulWidget {
//   const Shimmer(this.index, {Key? key}) : super(key: key);
//   final int index;

//   @override
//   State<Shimmer> createState() => _ShimmerState();
// }

// class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
//   late AnimationController opacityController;
//   late Animation<double> opacity;

//   @override
//   void initState() {
//     super.initState();
//     opacityController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//       reverseDuration: const Duration(milliseconds: 2000),
//     );
//     opacity = Tween(begin: 0.05, end: 1.0).animate(
//       CurvedAnimation(
//         parent: opacityController,
//         curve: Curves.fastLinearToSlowEaseIn,
//         reverseCurve: Curves.fastOutSlowIn,
//       ),
//     );

//     Future.delayed(
//       Duration(milliseconds: (widget.index + 1) * 200),
//       () => opacityController.forward(),
//     );

//     opacityController.addListener(() {
//       if (!opacityController.isAnimating) {
//         if (opacityController.isCompleted) {
//           Future.delayed(
//             const Duration(milliseconds: 200),
//             () => opacityController.reverse(),
//           );
//         } else {
//           Future.delayed(
//             const Duration(milliseconds: 200),
//             () => opacityController.forward(),
//           );
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     opacityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: opacity,
//       builder: (context, child) => Opacity(
//         opacity: opacity.value,
//         child: child,
//       ),
//       child: ,
//     );
//   }
// }
