import 'package:binpack_residents/views/global/adoptAcommunity/widgets/adoptACommunityHome.dart';

import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/residents/residets_request_screen/WasteRequestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomNavigationWidget extends StatefulWidget {
  final Residents resident;

  const BottomNavigationWidget({
    super.key,
    required this.resident,
  });

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  bool _isVisible = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isVisible ? kBottomNavigationBarHeight : 0.0,
      child: Wrap(
        children: [
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Color.fromARGB(255, 8, 116, 13)),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.car_rental,
                    color: Color.fromARGB(255, 8, 116, 13)),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_2_rounded,
                    color: Color.fromARGB(255, 8, 116, 13)),
                label: 'Community',
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WasteRequestCollection(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommunityGridPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
