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
      home: BoxHolder(),
    );
  }
}

class ShoppingCartButton extends StatefulWidget {
  const ShoppingCartButton({super.key});

  @override
  State<ShoppingCartButton> createState() => _ShoppingCartButtonState();
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ), // BoxDecoration
//             child: const Icon(
//               Icons.shopping_cart,
//               color: Colors.white,
//             ), // Icon
          ), // AnimatedContainer
        ), // GestureDetector
      ), // Center
    ); // Scaffold
  }
}

class BoxHolder extends StatefulWidget {
  const BoxHolder({super.key});

  @override
  State<BoxHolder> createState() => _BoxHolderState();
}

class _BoxHolderState extends State<BoxHolder> {
  final items = List<int>.generate(25, (index) => index);

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
          maxCrossAxisExtent: 250,
          onReorder: _onReorder,
          childAspectRatio: 1,
          children: items.map((item) {
            /// map every list entry to a widget and assure every child has a
            /// unique key
            return ShoppingCartButton(
              key: ValueKey(item),
            );
            // return Card(
            //   key: ValueKey(item),
            //   child: Center(
            //     child: Text(item.toString()),
            //   ),
            // );
          }).toList(),
        ),
      ),
    );
  }
}
