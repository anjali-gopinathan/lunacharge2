import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Grid extends StatefulWidget {
  final void Function(int index) onUpdateIndex;

  const Grid({super.key, required this.onUpdateIndex});

  @override
  State<Grid> createState() => GridState();
}

class GridState extends State<Grid> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 60),
        child: _buildGrid(),
      ),
    );
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }
  // @override
  // Widget build(BuildContext context) {
  //   return PhotoView.customChild(
  //     childSize: const Size(14 * (50 + 10), 10 * (50 + 10)),
  //     backgroundDecoration: const BoxDecoration(color: Colors.white),
  //     customSize: MediaQuery.of(context).size,
  //     minScale: PhotoViewComputedScale.contained * 0.8,
  //     maxScale: PhotoViewComputedScale.covered * 4,
  //     initialScale: PhotoViewComputedScale.covered,
  //     // enablePanAlways: true,
  //     // tightMode: true,
  //     child: Padding(
  //       padding: const EdgeInsets.all(30),
  //       child: _buildGrid(),
  //     ),
  //   );
  // }

  Widget _buildGrid() {
    return SizedBox(
      height: 10 * (60 + 10),
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 14,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(14 * 11, (index) {
          int row = index ~/ 14;
          int col = index % 14;
          Color color = index == _selectedIndex
              ? const Color(0xff809fed)
              : const Color(0xffF7F8F9);
          Color textColor =
              index == _selectedIndex ? Colors.white : Colors.black;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffcfcfcf)),
              color: color,
            ),
            child: InkWell(
              onTap: () {
                if (_selectedIndex == index) {
                  setState(() {
                    _selectedIndex = -1;
                  });
                  widget.onUpdateIndex(-1);
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onUpdateIndex(index);
                }
              },
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Text(
                    '$row, $col',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
