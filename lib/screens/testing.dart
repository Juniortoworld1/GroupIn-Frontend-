import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  // Renamed to 'items' (plural) for clarity
  final List<String> items = const ["hello world ", "hello bro ", "hello world 2"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        // This replaces GridView.count and handles your responsive columns
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 700 ? 4 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        // Tell the grid how many total items there are
        itemCount: items.length,
        // The grid will now loop through your items and give each its own tile
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
      ),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
      child: Text(items[index]),
    );
  }
}