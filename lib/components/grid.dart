import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:motor_flutter_starter/components/car.dart';

class Grid extends StatefulWidget {
  final void Function(int index) onUpdateIndex;
  final int carX;
  final int carY;

  const Grid({
    super.key,
    required this.onUpdateIndex,
    required this.carX,
    required this.carY,
  });

  @override
  State<Grid> createState() => GridState();
}

class GridState extends State<Grid> {
  late final ScrollController _scrollController;
  int _selectedIndex = -1;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: _buildStack(),
        ),
      ),
    );
  }

  Widget _buildStack() {
    double offset = 60.5;
    return Stack(
      children: [
        _buildGrid(),
        Positioned(
          top: -_scrollOffset - 23 + widget.carY * offset,
          left: -43 + widget.carX * offset,
          child: const Car(),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    double wh = 50;
    return SizedBox(
      height: 10 * (wh + 10),
      width: 14 * (wh + 10),
      child: GridView.count(
        controller: _scrollController,
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
                width: wh,
                height: wh,
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
