import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Featured Products Sliding Banner
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 8, 116, 13),
            ),
            child: const Center(
              child: Text('Featured Products Banner'),
            ),
          ),

          const SizedBox(height: 16),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton('Category 1', Icons.category),
                const SizedBox(width: 8),
                _buildCategoryButton('Category 2', Icons.category),
                const SizedBox(width: 8),
                _buildCategoryButton('Category 3', Icons.category),
                // Add more category buttons as needed
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Special Promotions
          const SizedBox(
            height: 150,
            child: // Your special promotions scrollable widget goes here
                Center(
              child: Text('Special Promotions'),
            ),
          ),

          const SizedBox(height: 16),

          // Products List Cards (2 Grids)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildProductCard('Product 1', 'Image 1'),
              _buildProductCard('Product 2', 'Image 2'),
              // Add more product cards as needed
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String categoryName, IconData icon) {
    return SizedBox(
      width: 120, // Adjust as needed
      child: ElevatedButton.icon(
        onPressed: () {
          // Handle category button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 8, 116, 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon),
        label: Text(categoryName),
      ),
    );
  }

  Widget _buildProductCard(String productName, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Replace with actual image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // Handle add to cart
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        // Handle like
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        // Handle review
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
