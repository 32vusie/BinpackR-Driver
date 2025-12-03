import 'package:binpack_residents/views/global/shop/screens/CartScreen/CartScreen.dart';
import 'package:binpack_residents/views/global/shop/screens/FinancialsScreen/FinancialsScreen.dart';
import 'package:binpack_residents/views/global/shop/screens/HomeScreen/HomeScreen.dart';
import 'package:binpack_residents/views/global/shop/screens/OrdersScreen/OrdersScreen.dart';
import 'package:binpack_residents/views/global/shop/screens/ProductScreen/ProductScreen.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const FinancialsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Shop Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
                color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
                color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.assignment, color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money,
                color: Color.fromARGB(255, 8, 116, 13)),
            label: 'Financials',
          ),
        ],
      ),
    );
  }
}
