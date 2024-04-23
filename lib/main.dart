import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BoxHolder(),
    );
  }
}

class AnimatedBox extends StatefulWidget {
  const AnimatedBox({super.key});

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 200.0 : 80.0,
            height: isExpanded ? 200.0 : 80.0,
            decoration: BoxDecoration(
              color: isExpanded ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3.0),
            ),
          ),
        ),
      ),
    );
  }
}

class BoxHolder extends StatefulWidget {
  const BoxHolder({super.key});

  @override
  State<BoxHolder> createState() => _BoxHolderState();
}

class _BoxHolderState extends State<BoxHolder> {
  final items = List<int>.generate(25, (index) => index);

  // Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  //   return AnimatedBuilder(
  //     animation: animation,
  //     builder: (BuildContext context, Widget? child) {
  //       return Material(
  //         elevation: 0,
  //         color: Colors.transparent,
  //         child: child,
  //       );
  //     },
  //     child: child,
  //   );
  // }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        // final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          // Create a Card based on the color and the content of the dragged one
          // and set its elevation to the animated value.
          child: child,
        );
      },
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ReorderableGridView.extent(
          proxyDecorator: proxyDecorator,
          maxCrossAxisExtent: 250,
          onReorder: _onReorder,
          childAspectRatio: 1,
          children: items.map((item) {
            return AnimatedBox(
              key: ValueKey(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
