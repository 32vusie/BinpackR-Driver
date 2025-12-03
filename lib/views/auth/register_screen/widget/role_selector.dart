import 'package:flutter/material.dart';
import 'package:binpack_residents/utils/theme.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRoleSelector(
          'Resident',
          'assets/images/Navigation-amico.png',
          isSelectable: true,
        ),
        _buildRoleSelector(
          'Business',
          'assets/images/barbershop-pana.png',
          isSelectable: false,
        ),
        _buildRoleSelector(
          'Driver',
          'assets/images/Pick-up-truck-amico.png',
          isSelectable: true,
        ),
      ],
    );
  }

  Widget _buildRoleSelector(String role, String imagePath,
      {required bool isSelectable}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: isSelectable
                  ? () {
                      onRoleSelected(role);
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == role ? primaryColor : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imagePath, width: 80, height: 80),
                ),
              ),
            ),
            if (!isSelectable)
              Positioned(
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (!isSelectable)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8), // Spacing between image and text
        Text(
          role,
          style: TextStyle(
            color: selectedRole == role ? primaryColor : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
