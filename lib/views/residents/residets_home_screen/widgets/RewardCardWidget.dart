import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final String rewardType;
  final int amount;

  const RewardCard({super.key, required this.rewardType, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Color.fromARGB(255, 8, 116, 13),
                ),
                const SizedBox(width: 16),
                Text(
                  rewardType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '$amount',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCardList extends StatelessWidget {
  const RewardCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rewards History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(color: Color.fromARGB(255, 8, 116, 13), width: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color.fromARGB(255, 8, 116, 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const RewardCard(
            rewardType: 'Points Spent',
            amount: 100,
          ),
          const SizedBox(height: 8),
          const RewardCard(
            rewardType: 'Points Received',
            amount: 200,
          ),
          const SizedBox(height: 8),
          const RewardCard(
            rewardType: 'Bonuses',
            amount: 50,
          ),
        ],
      ),
    );
  }
}
